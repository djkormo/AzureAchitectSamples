
AZURE_GROUP=rg-vm-test
AZURE_LOCATION=northeurope

AZURE_AVSET=myApacheMysqlAvailabilitySet

az configure --defaults group=$AZURE_GROUP

az configure --defaults location=$AZURE_LOCATION

# utworzenie nowej RG w lokalizacji Canada Central
az group create --name $AZURE_GROUP --location  $AZURE_LOCATION


# utworzenie VNET _+ subnet 
az network vnet create -g $AZURE_GROUP -n VNET01 --address-prefix 10.0.0.0/16 \
                            --subnet-name SUBNET01 --subnet-prefix 10.0.0.0/24

#  utworzenie zbioru wysokiej dostepnosci dla VM
az vm availability-set create \
  --resource-group $AZURE_GROUP \
  --name $AZURE_AVSET \
  --platform-fault-domain-count 2 \
  --platform-update-domain-count 2


# utworzenie dwoch VM z ubuntu  ramach tej samej Availabilty Set
for i in `seq 1 2`; do
   az vm create \
     --resource-group rg-tydzien-13-final \
     --name myapachemysql$i \
     --availability-set $AZURE_AVSET \
     --size Standard_A1_v2  \
     --image UbuntuLTS \
     --vnet-name VNET01 \
     --subnet SUBNET01 \
     --admin-username azureuser \
	 --admin-password Pa55word2018..

    az vm open-port --port 80 \
    --resource-group $AZURE_GROUP \
    --name myapachemysql$i \
    --priority 900

	az vm open-port --port 22 \
    --resource-group $AZURE_GROUP \
    --name myapachemysql$i \
    --priority 800
done

# instalacja oprogramowania na VM - działa na razie tylko z poziomu Cloud  Shell

for i in `seq 1 2`; do
az vm extension set \
  --resource-group $AZURE_GROUP \
  --vm-name myapachemysql$i \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --settings '{"fileUris": ["https://raw.githubusercontent.com/djkormo/AzureAchitectSamples/master/13Monitoring/install_apache_mysql_php.sh"],"commandToExecute": "./install_apache_mysql_php.sh"}'
done




