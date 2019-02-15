resource "aws_route53_record" "cortex" {
  name    = "${var.cluster_name}"
  type    = "A"
  zone_id = "${data.terraform_remote_state.core.k8s_devops_zone_id}"
  records = ["${aws_instance.master.*.public_ip}"]
  ttl     = 30
}

//resource "aws_route53_record" "elasticache" {
//  name    = "_memcache._tcp.elasticache.${var.cluster_name}"
//  type    = "SRV"
//  zone_id = "${data.terraform_remote_state.core.k8s_devops_zone_id}"
//  ttl     = 30
//  records = ["0 11 ${aws_elasticache_cluster.memcached.port} ${aws_elasticache_cluster.memcached.cluster_address}"]
//}

