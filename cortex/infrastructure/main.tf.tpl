provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {
    region         = "{{ ( ds "global" ).aws_region }}"
    bucket         = "{{ ( ds "global" ).terraform_state_bucket }}"
    key            = "{{ ( ds "global" ).terraform_state_cortex_key }}"
    dynamodb_table = "{{ ( ds "global" ).terraform_state_lock_table }}"
  }
}
