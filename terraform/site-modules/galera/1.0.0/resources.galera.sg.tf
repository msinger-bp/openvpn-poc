##  SST VIA RSYNC AND PERCONA XTRABACKUP
resource "aws_security_group_rule" "galera-sst" {
  description               = "${local.org-env-name} INTERNAL SST VIA RSYNC AND PERCONA XTRABACKUP"
  security_group_id         = "${module.cluster.sg_id}"
  type                      = "ingress"
  from_port                 = 4444
  to_port                   = 4444
  protocol                  = "TCP"
  source_security_group_id  = "${module.cluster.sg_id}"
}
##  GCOMM / WRITE-SET REPLICATION TRAFFIC (OVER TCP) AND MULTICAST REPLICATION (OVER TCP AND UDP).
resource "aws_security_group_rule" "galera-gcomm" {
  description               = "${local.org-env-name} INTERNAL GCOMM / WRITE-SET REPLICATION TRAFFIC AND MULTICAST REPLICATION"
  security_group_id         = "${module.cluster.sg_id}"
  type                      = "ingress"
  from_port                 = 4567
  to_port                   = 4567
  protocol                  = "TCP"
  source_security_group_id  = "${module.cluster.sg_id}"
}
##  IST / INCREMENTAL STATE TRANSFER
resource "aws_security_group_rule" "galera-ist" {
  description               = "${local.org-env-name} INTERNAL IST / INCREMENTAL STATE TRANSFER"
  security_group_id         = "${module.cluster.sg_id}"
  type                      = "ingress"
  from_port                 = 4568
  to_port                   = 4568
  protocol                  = "TCP"
  source_security_group_id  = "${module.cluster.sg_id}"
}
