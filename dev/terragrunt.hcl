remote_state {
  backend = "s3"

  config = {
    encrypt        = true
    key            = "${path_relative_to_include()}/terraform.tfstate"

    profile        = "bespin-training-terraform"      # You must change it to your named profile of aws cli.
    region         = "us-west-2"                      # You must change it to your state s3 bucket region.
    bucket         = "bespin-btc-dev-terraform-state" # You must change it to your state s3 bucket.
    dynamodb_table = "bespin-btc-dev-terraform-locks" # You must change it to your state dynamodb table.    
  }
}

terraform {
  extra_arguments "module_vars" {
    commands = get_terraform_commands_that_need_vars()

    optional_var_files = [
      "${get_terragrunt_dir()}/terraform.tfvars",
      "${get_terragrunt_dir()}/../module.tfvars",
      "${get_terragrunt_dir()}/../../module.tfvars"
    ]
  }
}

inputs = {
  aws_region  = "us-west-2"
  project     = "bespin" 
  stage       = "dev"
  tags        = { Owner = "bespinglobal" }

  env                    = "btc"                            # You must change it to environment code.
  aws_profile            = "bespin-training-terraform"      # You must change it to your named profile of aws cli.
  terraform_state_bucket = "bespin-btc-dev-terraform-state" # You must change it to your state s3 bucket.
}

skip = true
