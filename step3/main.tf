module "vm_with_networking" {
  // Re-implement to utilise step1 as your custom module
  source = ""
  rg_name = ""
  rg_location = ""
  prefix = []
  vnet_address_space = []
  subnet_address_space = []
  vm_admin_username = ""
  vm_admin_password = ""
}