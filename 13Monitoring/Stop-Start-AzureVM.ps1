Workflow Stop-Start-AzureVM 
{ 
    Param 
    (    
        [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
        [String] 
        $AzureVMList="All", 
        [Parameter(Mandatory=$true)][ValidateSet("Start","Stop","Reset")] 
        [String] 
        $Action ,
        [Parameter(Mandatory=$false)][ValidateNotNullOrEmpty()] 
        [String] 
        $ScriptName
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

    #$credential = Get-AutomationPSCredential -Name 'AzureCredential' 
    #Login-AzureRmAccount -Credential $credential 
    #Select-AzureRmSubscription -SubscriptionId $AzureSubscriptionId 
 
    if($AzureVMList -ne "All") 
    { 
        $AzureVMs = $AzureVMList.Split(",") 
        [System.Collections.ArrayList]$AzureVMsToHandle = $AzureVMs 
    } 
    else 
    { 
        $AzureVMs = (Get-AzureRmVM).Name 
        [System.Collections.ArrayList]$AzureVMsToHandle = $AzureVMs 
 
    } 
 
    foreach($AzureVM in $AzureVMsToHandle) 
    { 
        if(!(Get-AzureRmVM | ? {$_.Name -eq $AzureVM})) 
        { 
            throw " AzureVM : [$AzureVM] - Does not exist! - Check your inputs " 
        } 
    } 
 
    if($Action -eq "Stop") 
    { 
        Write-Output "------------------------ Stopping VM BEGIN ------------------------"
        Write-Output "Stopping VMs"; 
        foreach -parallel ($AzureVM in $AzureVMsToHandle) 
        { 
            Write-Output " Stopping AzureVM : [$AzureVM]  " 
            Get-AzureRmVM | ? {$_.Name -eq $AzureVM} | Stop-AzureRmVM -Force 
        } 
        Write-Output "------------------------ Stopping VM END ------------------------"
    } 
    if ($Action -eq "Start")
    {
        Write-Output "------------------------ Starting VM BEGIN ------------------------"
        Write-Output "Starting VMs"; 
        foreach -parallel ($AzureVM in $AzureVMsToHandle) 
        { 
            Write-Output " Starting AzureVM : [$AzureVM]  " 
            Get-AzureRmVM | ? {$_.Name -eq $AzureVM} | Start-AzureRmVM 
        }  
        Write-Output "------------------------ Starting VM END ------------------------"
    }
    # Resetting 
    if ($Action -eq "Reset")
    { 
        Write-Output "------------------------ Resetting VM BEGIN ------------------------"
        Write-Output "Downloading script for resetting services on VM"; 
        $FullScriptName= "https://raw.githubusercontent.com/djkormo/AzureAchitectSamples/master/13Monitoring/$ScriptName"
        Write-Output "Full script name : $FullScriptName"
        wget $FullScriptName -outfile $ScriptName

        Write-Output " Resetting services on VMs"; 
        foreach -parallel ($AzureVM in $AzureVMsToHandle) 
        { 
            Write-Output " Resetting AzureVM : [$AzureVM]  " 
           
            Get-AzureRmVM | ? {$_.Name -eq $AzureVM} | Invoke-AzureRmVMRunCommand  -CommandId 'RunShellScript' -ScriptPath $ScriptName
           

        } 

        Write-Output "------------------------ Resetting VM END ------------------------"

    } 
}