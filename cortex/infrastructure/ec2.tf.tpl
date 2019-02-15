resource "aws_instance" "master" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.master_type}"
  count         = "${var.master_count}"

  key_name                    = "${data.terraform_remote_state.core.ssh_key_name}"
  subnet_id                   = "${element(data.terraform_remote_state.core.public_subnet_ids, count.index)}"
  iam_instance_profile        = "${aws_iam_instance_profile.master.name}"
  vpc_security_group_ids      = ["${aws_security_group.cortex.id}"]
  associate_public_ip_address = true

  source_dest_check = false
  user_data         = "${data.template_file.user_data.rendered}"

  root_block_device {
    volume_size           = 16
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags {
    Name                               = "master${format("%02d", count.index)}.${var.cluster_name}"
    team                               = "${var.tag_team}"
    project                            = "${var.tag_project}"
    creator                            = "${var.tag_creator}"
    "kubernetes.io/cluster/{{ ( ds "global" ).cluster_name }}" = "owned"
  }

  lifecycle {
    ignore_changes = ["ami"]
  }
}

resource "aws_instance" "worker" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.worker_type}"
  count         = "${var.worker_count}"

  key_name                    = "${data.terraform_remote_state.core.ssh_key_name}"
  subnet_id                   = "${element(data.terraform_remote_state.core.public_subnet_ids, count.index)}"
  iam_instance_profile        = "${aws_iam_instance_profile.worker.name}"
  vpc_security_group_ids      = ["${aws_security_group.cortex.id}"]
  associate_public_ip_address = true

  source_dest_check = false
  user_data         = "${data.template_file.user_data.rendered}"

  root_block_device {
    volume_size           = 64
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags {
    Name                               = "worker${format("%02d", count.index)}.${var.cluster_name}"
    team                               = "${var.tag_team}"
    project                            = "${var.tag_project}"
    creator                            = "${var.tag_creator}"
    "kubernetes.io/cluster/{{ ( ds "global" ).cluster_name }}" = "owned"
  }

  lifecycle {
    ignore_changes = ["ami"]
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.tpl")}"

  vars {
    ssh_keys = "${join("  - ", formatlist("%s\n", var.ssh_keys))}"
  }
}
