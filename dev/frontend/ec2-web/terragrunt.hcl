dependencies {
  paths = ["../../network", "../alb-web"] # When applying this terragrunt config in an `run-all` command, make sure the modules at "../../network" and "../alb-web" are handled first.
}

terraform {
  source = "git::https://github.com/Changsuk-Choi/Terragrunt-Template.git//aws/ec2-web?ref=ec2-web-v1.0.0"
}

include {
  path = find_in_parent_folders()
}

# specify module parameters here
inputs = {
}
