terraform {
  source = "git::https://github.com/Changsuk-Choi/Terragrunt-Template.git//aws/iam?ref=iam-v1.0.0"
}

include {
  path = find_in_parent_folders()
}

# specify module parameters here
inputs = {
}
