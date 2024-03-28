Assignment: PowerShell Azure Resource Management

Objective:
The objective of this assignment is to assess your understanding of managing Azure resources using PowerShell.

Tasks:

Resource Group Creation:
Create a new resource group named MyResourceGroup in the Azure region of your choice using PowerShell.

Storage Account Creation:
Within the MyResourceGroup, create a new storage account named mystorageaccount with the following
configurations:
SKU: Standard_LRS
Kind: StorageV2

Virtual Machine Creation:
Create a new virtual machine named MyVM in the MyResourceGroup with the following specifications:
Image: Windows Server 2019 Datacenter
VM Size: Standard_DS1_v2
Username: azureuser
Password: <YourPreferredPassword>

Network Security Group (NSG) Creation:
Create a new NSG named MyNSG with the following rules:
Allow inbound traffic on port 3389 (RDP) from any source.
Allow inbound traffic on port 80 (HTTP) from any source.

Attach NSG to Virtual Machine:

Attach the MyNSG to the network interface of MyVM.

