﻿Workflow HandleAzureVirtualMachinesPowerState
{
    param (

        [Parameter(Mandatory=$true)]  
        [String] $Action,

        [Parameter(Mandatory=$false)]  
        [String] $TagName,

        [Parameter(Mandatory=$false)]
        [String] $TagValue
    ) 

    ## Authentication
    Write-Output ""
    Write-Output "------------------------ Authentication ------------------------"
    Write-Output "Logging in to Azure ..."

    try
    {
        $connectionName = "AzureRunAsConnection"

        # Get the connection "AzureRunAsConnection "
        $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName         

        $null = Add-AzureRmAccount `
                    -ServicePrincipal `
                    -TenantId $servicePrincipalConnection.TenantId `
                    -ApplicationId $servicePrincipalConnection.ApplicationId `
                    -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint

        Write-Output "Successfully logged in to Azure." 
    } 
    catch
    {
        if (!$servicePrincipalConnection)
        {
            $ErrorMessage = "Connection $connectionName not found."
            throw $ErrorMessage
        } 
        else
        {
            Write-Error -Message $_.Exception
            throw $_.Exception
        }
    }
    ## End of authentication

    ## Getting all virtual machines
    Write-Output ""
    Write-Output ""
    Write-Output "---------------------------- Status ----------------------------"
    Write-Output "Getting all virtual machines from all resource groups ..."

    try
    {
        $resourceGroupsContent = @()
        $resourceGroups = Get-AzureRmResourceGroup

        foreach ($resourceGroup in $resourceGroups)
        {
            if ($TagName)
            {                    
                $instances = Find-AzureRmResource -TagName $TagName -TagValue $TagValue | Where-Object {($_.ResourceType -eq "Microsoft.Compute/virtualMachines") -and ($_.ResourceGroupName -eq $resourceGroup.ResourceGroupName)}
            
                if ($instances)
                {               
                    foreach -parallel ($instance in $instances)
                    {
                        $instancePowerState = (((Get-AzureRmVM -ResourceGroupName $resourceGroup.ResourceGroupName -Name $instance.ResourceName -Status).Statuses.Code[1]) -replace "PowerState/", "")

                        sequence
                        {
                            $resourceGroupContent = New-Object -Type PSObject -Property @{
                                "Resource group name" = $($resourceGroup.ResourceGroupName)
                                "Instance name" = $($instance.ResourceName)
                                "Instance type" = (($instance.ResourceType -split "/")[0].Substring(10))
                                "Instance state" = ([System.Threading.Thread]::CurrentThread.CurrentCulture.TextInfo.ToTitleCase($instancePowerState))
                                $TagName = $TagValue
                            }

                            $Workflow:resourceGroupsContent += $resourceGroupContent
                        }
                    }
                }
                else
                {
                }            
            }
            else
            {
                $instances = Find-AzureRmResource | Where-Object {($_.ResourceType -eq "Microsoft.Compute/virtualMachines") -and ($_.ResourceGroupName -eq $resourceGroup.ResourceGroupName)}

                if ($instances)
                {               
                    foreach -parallel ($instance in $instances)
                    {
                        $instancePowerState = (((Get-AzureRmVM -ResourceGroupName $resourceGroup.ResourceGroupName -Name $instance.ResourceName -Status).Statuses.Code[1]) -replace "PowerState/", "")

                        sequence
                        {
                            $resourceGroupContent = New-Object -Type PSObject -Property @{
                                "Resource group name" = $($resourceGroup.ResourceGroupName)
                                "Instance name" = $($instance.ResourceName)
                                "Instance type" = (($instance.ResourceType -split "/")[0].Substring(10))
                                "Instance state" = ([System.Threading.Thread]::CurrentThread.CurrentCulture.TextInfo.ToTitleCase($instancePowerState))
                            }

                            $Workflow:resourceGroupsContent += $resourceGroupContent
                        }
                    }
                }
                else
                {
                }
            }
        }

        InlineScript
        {
            $Using:resourceGroupsContent | Format-Table -AutoSize
        }
    }
    catch
    {
        Write-Error -Message $_.Exception
        throw $_.Exception    
    }
    ## End of getting all virtual machines

    $runningInstances = ($resourceGroupsContent | Where-Object {$_.("Instance state") -eq "Running" -or $_.("Instance state") -eq "Starting"})
    $deallocatedInstances = ($resourceGroupsContent | Where-Object {$_.("Instance state") -eq "Deallocated" -or $_.("Instance state") -eq "Deallocating"})

    ## Updating virtual machines power state
    if (($runningInstances) -and ($Action -eq "Stop"))
    {
        Write-Output "--------------------------- Updating ---------------------------"
        Write-Output "Trying to stop virtual machines ..."

        try
        {
            $updateStatuses = @()

            foreach -parallel ($runningInstance in $runningInstances)
            {
                sequence
                {
                    Write-Output "$($runningInstance.("Instance name")) is shutting down ..."
                
                    $startTime = Get-Date -Format G

                    $stopRunningInstance = Stop-AzureRmVM -ResourceGroupName $($runningInstance.("Resource group name")) -Name $($runningInstance.("Instance name")) -Force
                    
                    $endTime = Get-Date -Format G

                    $updateStatus = New-Object -Type PSObject -Property @{
                        "Resource group name" = $($runningInstance.("Resource group name"))
                        "Instance name" = $($runningInstance.("Instance name"))
                        "Start time" = $startTime
                        "End time" = $endTime
                    }
                
                    $Workflow:updateStatuses += $updateStatus
                }          
            }

            InlineScript
            {
                $Using:updateStatuses | Format-Table -AutoSize
            }
        }
        catch
        {
            Write-Error -Message $_.Exception
            throw $_.Exception    
        }
    }
    elseif (($deallocatedInstances) -and ($Action -eq "Start"))
    {
        Write-Output "--------------------------- Updating ---------------------------"
        Write-Output "Trying to start virtual machines ..."

        try
        {
            foreach -parallel ($deallocatedInstance in $deallocatedInstances)
            {                                    
                sequence
                {
                    Write-Output "$($deallocatedInstance.("Instance name")) is starting ..."

                    $startTime = Get-Date -Format G

                    $startDeallocatedInstance = Start-AzureRmVM -ResourceGroupName $($deallocatedInstance.("Resource group name")) -Name $($deallocatedInstance.("Instance name"))

                    $endTime = Get-Date -Format G

                    $updateStatus = New-Object -Type PSObject -Property @{
                        "Resource group name" = $($deallocatedInstance.("Resource group name"))
                        "Instance name" = $($deallocatedInstance.("Instance name"))
                        "Start time" = $startTime
                        "End time" = $endTime
                    }
                
                    $Workflow:updateStatuses += $updateStatus
                }
            
            }

            InlineScript
            {
                $Using:updateStatuses | Format-Table -AutoSize
            }
        }
        catch
        {
            Write-Error -Message $_.Exception
            throw $_.Exception    
        }
    }
    #### End of updating virtual machines power state
}