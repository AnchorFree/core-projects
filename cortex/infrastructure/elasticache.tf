//resource "aws_elasticache_cluster" "memcached" {
//  cluster_id         = "${var.cluster_name}"
//  engine             = "memcached"
//  node_type          = "cache.m5.large"
//  num_cache_nodes    = 3
//  port               = 11211
//  security_group_ids = ["${aws_security_group.cortex.id}"]
//  subnet_group_name  = "${aws_elasticache_subnet_group.memcached.name}"
//}
//
//resource "aws_elasticache_subnet_group" "memcached" {
//  name       = "${var.cluster_name}"
//  subnet_ids = ["${data.terraform_remote_state.core.public_subnet_ids}"]
//}

