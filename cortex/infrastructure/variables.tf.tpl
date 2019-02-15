variable "aws_region" {
  type    = "string"
  default = "{{ ( ds "global" ).aws_region }}"
}

variable "tag_team" {
  type    = "string"
  default = "core"
}

variable "tag_project" {
  type    = "string"
  default = "aws-cortex"
}

variable "tag_creator" {
  type    = "string"
  default = "zunkree"
}

variable "master_count" {
  type    = "string"
  default = "3"
}

variable "master_type" {
  type    = "string"
  default = "c5.large"
}

variable "worker_count" {
  type    = "string"
  default = "9"
}

variable "worker_type" {
  type    = "string"
  default = "c5.2xlarge"
}

variable "ssh_keys" {
  type = "list"

  default = [
{{- range ( ds "global" ).ssh_keys }}
    "{{.}}",
{{- end }}
  ]
}

variable "terraform_state_bucket" {
  type    = "string"
  default = "{{ ( ds "global" ).terraform_state_bucket }}"
}

variable "terraform_state_core_key" {
  type    = "string"
  default = "{{ ( ds "global" ).terraform_state_core_key }}"
}

variable "cortex_s3_bucket" {
  type    = "string"
  default = "{{ ( ds "global" ).cortex_s3_bucket }}"
}

variable "cortex_dynamodb_table" {
  type    = "string"
  default = "{{ ( ds "global" ).cortex_dynamodb_table }}"
}

variable "cluster_name" {
  type    = "string"
  default = "{{ ( ds "global" ).cluster_name }}"
}
