resource "aws_dynamodb_table" "cortex" {
  name         = "${var.cortex_dynamodb_table}"
  hash_key     = "h"
  range_key    = "r"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "h"
    type = "S"
  }

  attribute {
    name = "r"
    type = "B"
  }

  tags {
    team                               = "${var.tag_team}"
    project                            = "${var.tag_project}"
    creator                            = "${var.tag_creator}"
    "kubernetes.io/cluster/{{ ( ds "global" ).cluster_name }}" = "shared"
  }
}
