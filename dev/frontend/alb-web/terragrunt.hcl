dependencies {
  paths = ["../../network"] # When applying this terragrunt config in an `run-all` command, make sure the modules at "../../network" is handled first.
}

terraform {
  source = "git::https://github.com/Changsuk-Choi/Terragrunt-Template.git//aws/alb-web?ref=alb-web-v1.0.0"
}

include {
  path = find_in_parent_folders()
}

# specify module parameters here
inputs = {
  target_type            = "instance"
  allow_http_cidr_blocks = [ "0.0.0.0/0" ]
  logging_bucket         = "bespin-dev-web-logging"
}
