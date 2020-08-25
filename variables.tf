######################
#--Azure Env Params--#
######################

#--Azure Location. Change as appropriate
variable "location" {
    type         = string
    description  = "Location"
    default      = "uksouth"
}

#--Prompt for your subscription ID
variable "subscription_id" {
    type        = string
    description = "Subscription id"
}

#--Prompt for your Tenant ID
variable "tenant_id" {
    type        = string
    description = "Tenant id"
}

##################
#--Auth params--##
##################

#--Prompt for your Client ID
variable "client_id" {
    type        = string
    description = "Client id"
}

#--Prompt for your Client Secret (Service Principle Secret)
variable "client_secret" {
    type        = string
    description = "Client secret"
}

#--OS Admin User (set to something)
variable "admin_user" {
    type        = string
    description = "Admin Username"
    default     = "tinfoiladmin"
}

#--OS Admin Password (set to something decent, in production you'd really want to look this up from Vault)
variable "admin_pass" {
    type        = string
    description = "Admin Password"
    default     = "Tinfoilpassword12345"
}

#--Resource Groups
variable "resource_groups" {
    description = "All resource groups"
    type        = list(string)
    default     = ["tinfoil_network_rg",
                 "tinfoil_compute_rg",
                 "tinfoil_storage_rg"]
}

################
#--Networking--#
################

variable "vnet" {
    description = "Base vnet"
    type        = string
    default     = "tinfoil_vnet"
}

variable "subnet" {
    description = "Base Subnet"
    type        = string
    default     = "tinfoil_subnet"
}

variable "linux_vm_nics" {
    description = "Linux VM NICs"
    type        = list(string)
    default     = ["tinfoil_apps01-nic",
                 "tinfoil_security01-nic",]
}

#############
#--Storage--#
#############

variable "storageaccounts" {
    description = "All Storage Accounts"
    type        = list(string)
    default     = ["tinfoilstorageblob",
                 "tinfoilstorageshare",]
}

#############
#--Compute--#
#############

variable "linux_vms" {
    description = "All Linux VMs"
    type        = list(string)
    default     = ["tinfoil-apps01-vm",
                 "tinfoil-security01-vm",]
}

variable "linux_vm_osdisks" {
    description = "All Linux VM OS Disks"
    type        = list(string)
    default     = ["tinfoil_apps01_osdisk",
                 "tinfoil_security01_osdisk",]
}
