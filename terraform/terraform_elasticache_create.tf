
#Elasticache session state cluster

resource "aws_elasticache_cluster" "session_handler" {
  cluster_id           = "session_handler"
  engine               = "memcached"
  node_type            = "cache.m3.medium"
  num_cache_nodes      = 2
  parameter_group_name = "default.memcached1.4"
  security_group_name = ["$(aws_security_group.security_group.id)"]
  port                 = 11211
}
