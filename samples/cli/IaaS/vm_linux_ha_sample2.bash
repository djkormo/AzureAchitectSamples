#!/bin/bash

#based on https://docs.microsoft.com/pl-pl/azure/networking/scripts/load-balancer-linux-cli-sample-nlb

AZURE_GROUP=rg-vm-test2
AZURE_LOCATION=westeurope
AZURE_VMSIZE=Standard_A1_v2
AZURE_AVSET=myAvailabilitySet

az configure --defaults group=$AZURE_GROUP

az configure --defaults location=$AZURE_LOCATION


# Create a resource group.
az group create --name $AZURE_GROUP --location $AZURE_LOCATION

# Create a virtual network.
az network vnet create --resource-group $AZURE_GROUP --location $AZURE_LOCATION \
  --name myVnet --subnet-name mySubnet

# Create a public IP address.
az network public-ip create --resource-group $AZURE_GROUP --name myPublicIP

# Create an Azure Load Balancer.
az network lb create --resource-group $AZURE_GROUP --name myLoadBalancer --public-ip-address myPublicIP \
  --frontend-ip-name myFrontEndPool --backend-pool-name myBackEndPool

# Creates an LB probe on port 80.
az network lb probe create --resource-group $AZURE_GROUP --lb-name myLoadBalancer \
  --name myHealthProbe --protocol tcp --port 80

# Creates an LB rule for port 80.
az network lb rule create --resource-group $AZURE_GROUP --lb-name myLoadBalancer --name myLoadBalancerRuleWeb \
  --protocol tcp --frontend-port 80 --backend-port 80 --frontend-ip-name myFrontEndPool \
  --backend-pool-name myBackEndPool --probe-name myHealthProbe

# Create three NAT rules for port 22.
for i in `seq 1 2`; do
  az network lb inbound-nat-rule create \
    --resource-group $AZURE_GROUP --lb-name myLoadBalancer \
    --name myLoadBalancerRuleSSH$i --protocol tcp \
    --frontend-port 422$i --backend-port 22 \
    --frontend-ip-name myFrontEndPool
done

# Create a network security group
az network nsg create --resource-group $AZURE_GROUP --name myNetworkSecurityGroup

# Create a network security group rule for port 22.
az network nsg rule create --resource-group $AZURE_GROUP --nsg-name myNetworkSecurityGroup \
  --name myNetworkSecurityGroupRuleSSH \
  --protocol tcp --direction inbound --source-address-prefix '*' --source-port-range '*'  \
  --destination-address-prefix '*' --destination-port-range 22 --access allow --priority 1000

# Create a network security group rule for port 80.
az network nsg rule create --resource-group $AZURE_GROUP --nsg-name myNetworkSecurityGroup \
--name myNetworkSecurityGroupRuleHTTP \
--protocol tcp --direction inbound  --destination-port-range 80 --access allow --priority 2000

# Create two virtual network cards and associate with public IP address and NSG.
for i in `seq 1 2`; do
  az network nic create \
    --resource-group $AZURE_GROUP --name myNic$i \
    --vnet-name myVnet --subnet mySubnet \
    --network-security-group myNetworkSecurityGroup --lb-name myLoadBalancer \
    --lb-address-pools myBackEndPool --lb-inbound-nat-rules myLoadBalancerRuleSSH$i
done

# Create an availability set.
az vm availability-set create --resource-group $AZURE_GROUP \
  --name $AZURE_AVSET --platform-fault-domain-count 2 --platform-update-domain-count 2

# Create three virtual machines, this creates SSH keys if not present.
for i in `seq 1 2`; do
  az vm create \
    --resource-group $AZURE_GROUP \
    --name myVM$i \
	--size $AZURE_VMSIZE  \
    --availability-set $AZURE_AVSET \
    --nics myNic$i \
    --image UbuntuLTS \
    --admin-username azureuser \
	--admin-password Pa55word2018..
    

done


for i in `seq 1 2`; do
az vm extension set \
  --resource-group $AZURE_GROUP \
  --vm-name myVM$i \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --settings '{"fileUris": ["https://raw.githubusercontent.com/djkormo/AzureAchitectSamples/master/samples/cli/IaaS/install_apache_php.bash"],"commandToExecute": "./install_apache_php.bash"}'
done


