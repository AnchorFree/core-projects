data "template_file" "kubespray_inventory" {
  template = "${file("${path.module}/infra.yaml.tpl")}"

  vars {
    master_nodes        = "${join("\n", formatlist("- name: \"%v\"\n  ip: \"%v\"\n  ansible_host: \"%v\"\n  ansible_user: \"ubuntu\"\n  etcd_member: true\n  master_member: true", aws_instance.master.*.private_dns, aws_instance.master.*.private_ip, aws_instance.master.*.public_ip))}"
    worker_nodes        = "${join("\n", formatlist("- name: \"%v\"\n  ip: \"%v\"\n  ansible_host: \"%v\"\n  ansible_user: \"ubuntu\"\n  etcd_member: false\n  master_member: false", aws_instance.worker.*.private_dns, aws_instance.worker.*.private_ip, aws_instance.worker.*.public_ip))}"
    k8s_api_endpoint    = "${aws_route53_record.cortex.fqdn}"
    s3_url              = "s3://${var.aws_region}/${aws_s3_bucket.cortex.bucket}"
    dynamodb_url        = "dynamodb://${var.aws_region}"
    dynamodb_table_name = "${aws_dynamodb_table.cortex.name}"
  }
}

output "kubespray_inventory" {
  value = "\n${data.template_file.kubespray_inventory.rendered}"
}

resource "local_file" "infra" {
  filename = "${path.module}/infra.yaml"
  content = "${data.template_file.kubespray_inventory.rendered}"
}