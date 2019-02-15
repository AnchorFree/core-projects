resource "aws_s3_bucket" "cortex" {
  bucket = "${var.cortex_s3_bucket}"

  tags {
    team                               = "${var.tag_team}"
    project                            = "${var.tag_project}"
    creator                            = "${var.tag_creator}"
    "kubernetes.io/cluster/{{ ( ds "global" ).cluster_name }}" = "owned"
  }
}
