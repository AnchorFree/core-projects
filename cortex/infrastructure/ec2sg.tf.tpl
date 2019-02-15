resource "aws_security_group" "cortex" {
  name   = "${var.cluster_name}"
  vpc_id = "${data.terraform_remote_state.core.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    team                               = "${var.tag_team}"
    project                            = "${var.tag_project}"
    creator                            = "${var.tag_creator}"
    "kubernetes.io/cluster/{{ ( ds "global" ).cluster_name }}" = "shared"
  }
}
