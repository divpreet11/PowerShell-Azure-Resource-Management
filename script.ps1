# Declaring the Variable
$resource_group_name = "MyResourceGroup"
$resource_group_Location = "East US"
 
#Creation of Resource Group
 # Check if the resource group already exists
if (!(Get-AzResourceGroup -Name $resource_group_name -ErrorAction SilentlyContinue)) {
    # If the resource group doesn't exist, create it
    New-AzResourceGroup -Name $resource_group_name -Location $resource_group_Location
    Write-Output "Resource group '$resource_group_name' created successfully in the $resource_group_Location region."
} else {
    Write-Output "Resource group '$resource_group_name' already exists."
}

# Create the storage account
# Declaring the variable
$storageAccountName = "divpreetstorageaccount"
New-AzStorageAccount -ResourceGroupName $resource_group_name `
                     -Name $storageAccountName `
                     -SkuName "Standard_LRS" `
                     -Kind "StorageV2" `
                     -Location $resource_group_Location


# Create a Public IP address

$publicIp = New-AzPublicIpAddress -ResourceGroupName $resource_group_name -Name "MyPublicIP" -AllocationMethod Static -Location $resource_group_Location
 
# Wait for Public IP creation

Write-Host "Waiting for Public IP to be created..."

do {

    $publicIp = Get-AzPublicIpAddress -ResourceGroupName $resource_group_name -Name "MyPublicIP" -ErrorAction SilentlyContinue

    Start-Sleep -Seconds 10

} while (-not $publicIp)
 
# Check if Public IP was successfully created

if (-not $publicIp) {

    Write-Error "Failed to create Public IP. Exiting..."

    exit

}
 
# Create a subnet configuration

$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name "MySubnet" -AddressPrefix "10.0.0.0/24"
 
# Create a virtual network

$vnet = New-AzVirtualNetwork -ResourceGroupName $resource_group_name -Location $resource_group_Location -Name "MyVNet" -AddressPrefix "10.0.0.0/16" -Subnet $subnetConfig
 
# Wait for Virtual Network creation

Write-Host "Waiting for Virtual Network to be created..."

do {

    $vnet = Get-AzVirtualNetwork -ResourceGroupName $resource_group_name -Name "MyVNet" -ErrorAction SilentlyContinue

    Start-Sleep -Seconds 10

} while (-not $vnet)
 
# Check if Virtual Network was successfully created

if (-not $vnet) {

    Write-Error "Failed to create Virtual Network. Exiting..."

    exit

}
 
# Create a network interface and associate it with NSG, public IP, and subnet

$nic = New-AzNetworkInterface -Name "MyNIC" -ResourceGroupName $resource_group_name -Location $resource_group_Location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $publicIp.Id -NetworkSecurityGroupId $NSG.Id
 
# Wait for NIC creation

Write-Host "Waiting for NIC to be created..."

do {

    $nic = Get-AzNetworkInterface -Name "MyNIC" -ResourceGroupName $resource_group_name -ErrorAction SilentlyContinue

    Start-Sleep -Seconds 10

} while (-not $nic)
 
# Check if NIC was successfully created

if (-not $nic) {

    Write-Error "Failed to create NIC. Exiting..."

    exit

}
 
# Create the VM configuration

$VM_name = "myVM"

$cred = Get-Credential -Message "Enter a username and password for the virtual machine."

$VM = New-AzVMConfig -VMName $VM_name -VMSize 'Standard_DS1_v2'

$VM = Set-AzVMOperatingSystem -VM $VM -Windows -ComputerName $VM_name -Credential $cred -ProvisionVMAgent -EnableAutoUpdate

$VM = Add-AzVMNetworkInterface -VM $VM -Id $nic.Id
 
# Create the OS disk

$VM = Set-AzVMOSDisk -VM $VM -Name "osdisk1" -CreateOption FromImage -Windows
 
# Create the VM

$GETVM=New-AzVM -ResourceGroupName $resource_group_name -Location $resource_group_Location -VM $VM -ErrorAction SilentlyContinue

# Wait for NIC creation

Write-Host "Waiting for VM to be created..."

do {

    $GETVM = Get-AzVM -Name $VM_name -ResourceGroupName $resource_group_name -ErrorAction SilentlyContinue

    Start-Sleep -Seconds 10

} while (-not $GETVM)
 
# Check if NIC was successfully created

if (-not $GETVM) {

    Write-Error "Failed to create VM. Exiting..."

    exit

}

Write-Host "All resources created Successfully"
