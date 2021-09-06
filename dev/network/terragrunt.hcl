terraform {
  source = "git::https://github.com/Changsuk-Choi/Terragrunt-Template.git//aws/network?ref=network-v1.0.0"
}

include {
  path = find_in_parent_folders()
}

# specify module parameters here
inputs = {
  vpc_cidr                   = "10.10.0.0/16"

  public_subnet_common_cidrs = [ "10.10.0.0/20",   "10.10.16.0/20" ]
  nat_subnet_api_cidrs       = [ "10.10.32.0/20",  "10.10.48.0/20" ]
  private_subnet_cache_cidrs = [ "10.10.100.0/24", "10.10.151.0/24" ]
  private_subnet_db_cidrs    = [ "10.10.101.0/24", "10.10.152.0/24" ]
  
  availability_zones         = [ "us-west-2a", "us-west-2c" ]
}
