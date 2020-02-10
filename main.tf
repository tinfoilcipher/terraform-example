#--Create Resource Groups
resource "azurerm_resource_group" "tinfoil" {
    name        = "${var.resource_groups[count.index]}"
    location    = "${var.location}"
    count       = 3
}
#--Create VNet
resource "azurerm_virtual_network" "tinfoil" {
    name                = "${var.vnet}"
    location            = "${var.location}"
    resource_group_name = "${var.resource_groups[0]}"
    address_space       = ["10.0.0.0/16"]
}
#--Create Subnet
resource "azurerm_subnet" "tinfoil" {
    name                 = "${var.subnet}"
    resource_group_name  = "${var.resource_groups[0]}"
    virtual_network_name = "${var.vnet}"
    address_prefix       = "10.0.1.0/24"
}
#--Create NSG
resource "azurerm_network_security_group" "tinfoil" {
    name                = "tinfoil-nsg"
    location            = "${var.location}"
    resource_group_name = "${var.resource_groups[0]}"
    security_rule {
        name                       = "DNS-IN"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "53"
        destination_port_range     = "53"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}
#--Apply NSG to Subnet
resource "azurerm_subnet_network_security_group_association" "tinfoil" {
    subnet_id                 = "${azurerm_subnet.tinfoil.id}"
    network_security_group_id = "${azurerm_network_security_group.tinfoil.id}"
}
#--Create NICs
resource "azurerm_network_interface" "tinfoil" {
    name                = "${var.linux_vm_nics[count.index]}"
    count               = "${length(var.linux_vms)}"
    location            = "${var.location}"
    resource_group_name = "${var.resource_groups[1]}"
    ip_configuration {
        name                          = "ipconfig"
        subnet_id                     = "${azurerm_subnet.tinfoil.id}"
        private_ip_address_allocation = "Dynamic"
    }
}
#--Create Storage Accounts
resource "azurerm_storage_account" "tinfoil" {
    name                     = "${var.storageaccounts[count.index]}"
    resource_group_name      = "${var.resource_groups[2]}"
    location                 = "${var.location}"
    account_tier             = "Standard"
    account_replication_type = "GRS"
    count                    = "${length(var.storageaccounts)}"
}
#--Create VMs. Crazy Interpolation on the NIC assignments is utterly essential. Thanks Microsoft
resource "azurerm_virtual_machine" "vms" {
    name                  = "${var.linux_vms[count.index]}"
    count                 = "${length(var.linux_vms)}"
    location              = "${var.location}"
    resource_group_name   = "${var.resource_groups[1]}"
    network_interface_ids = ["${element(azurerm_network_interface.tinfoil.*.id, count.index)}"]
    vm_size               = "Standard_b1ls"
    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04-LTS"
        version   = "latest"
    }
    storage_os_disk {
    name              = "${var.linux_vm_osdisks[count.index]}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "${var.linux_vms[count.index]}"
        admin_username = "${var.admin_user}"
        admin_password = "${var.admin_pass}"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}
