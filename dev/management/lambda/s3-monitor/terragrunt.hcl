terraform {
  source = "git::https://github.com/Changsuk-Choi/Terragrunt-Template.git//aws/lambda-s3?ref=lambda-s3-v1.0.0"
}

include {
  path = find_in_parent_folders()
}

# specify module parameters here
inputs = {
  schedule_expression = "cron(00 8 * * ? *)"
}
