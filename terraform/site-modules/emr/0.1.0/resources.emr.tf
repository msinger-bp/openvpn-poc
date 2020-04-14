##  https://github.com/terraform-providers/terraform-provider-aws/issues/1530
##  https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-configure-apps.html
##  https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-fs.html
##  https://docs.aws.amazon.com/emr/latest/ManagementGuide/emrfs-configure-consistent-view.html
data "template_file" "emr_config" {
  template = <<EOF
[
  {
     "classification":                              "emrfs-site",
     "properties":{
        "fs.s3.consistent.retryPeriodSeconds":      "10",
        "fs.s3.consistent":                         "true",
        "fs.s3.consistent.retryCount":              "5",
        "fs.s3.consistent.metadata.read.capacity":  "600",
        "fs.s3.consistent.metadata.write.capacity": "300",
        "fs.s3.consistent.metadata.tableName":      "EmrFSMetadata"
     },
     "configurations":[
     ]
  }
]
EOF
}

resource "aws_emr_cluster" "this" {
  name                                  = "${local.org-env-name}"
  release_label                         = "${var.emr_release_label}"
  applications                          = ["Sqoop", "Hadoop", "ZooKeeper", "Hive"]
  applications                         = ["Hadoop"]
  termination_protection                = "${var.termination_protection}"
  keep_job_flow_alive_when_no_steps     = true

  ##  NOTE: CHANGING THE LOG BUCKET URI WILL FORCE RE-CREATION OF THE CLUSTER :/
  log_uri                               = "${local.log_bucket_uri}"

  ec2_attributes {
    subnet_id                           = "${module.subnet_group.subnet_ids[0]}"
    emr_managed_master_security_group   = "${aws_security_group.master.id}"
    additional_master_security_groups   = "${var.vpc_strings["admin-access_sg_id"]}"
    emr_managed_slave_security_group    = "${aws_security_group.slave.id}"
    additional_slave_security_groups    = "${var.vpc_strings["admin-access_sg_id"]}"
    service_access_security_group       = "${aws_security_group.service.id}"
    instance_profile                    = "${aws_iam_instance_profile.emr_profile.arn}"
    key_name                            = "${var.env_strings["ec2_key"]}"
  }

  master_instance_group {
    instance_type                       = "${var.master_instance_type}"
    instance_count                      = "${var.master_instance_count}"
  }

  core_instance_group {
    instance_type                       = "${var.core_instance_type}"
    instance_count                      = "${var.core_instance_count}"
    ebs_config {
      size                              = "${var.core_instance_ebs_size}"
      type                              = "${var.core_instance_ebs_type}"
      volumes_per_instance              = "${var.core_instance_ebs_vols_per_instance}"
    }
  }

  configurations                        = "${data.template_file.emr_config.rendered}"

  ebs_root_volume_size                  = "${var.ebs_root_volume_size}"

  bootstrap_action                      = [
    ##  INSTALL YUM PACKAGES
    {
      path                              = "s3://${aws_s3_bucket.bootstrap.id}/${aws_s3_bucket_object.bootstrap_script_install_yum_packages.key}"
      name                              = "install_yum_packages"
      ##  LIST OF PACKAGES
      args                              = [
        "mysql-connector-java",
        "mysql-common"
      ]
    },
    ##  INSTALL HADOOP USER PUBLIC SSH KEY
    {
      path                              = "s3://${aws_s3_bucket.bootstrap.id}/${aws_s3_bucket_object.bootstrap_script_hadoop_ssh_pub_key.key}"
      name                              = "hadoop_ssh_pub_key"
      ##  PUBLIC KEY FROM FILE IN REPO
      args                              = [ "${ file("${path.module}/../../../../site-cookbooks/emr/files/default/emr.pub") }" ]
      ##  PUBLIC KEY IN PLAIN TEXT
      #args                             = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC59FoBZ8xlWmINF+eNJax+YfB7ukA4t7Qijzu0KaobDTIvOdhZ+RNQ0M5yrn6hsNwgG9YLPXgq0U07B++OZwsfkqPzKn/TQqCdBkVhnUl8r8/kHMg5ls3MmFboi0a7sCRJPmDsm64Hm9DuWe9TJWWoXCngnfuF4C7ktjzEru0fNpVz4CZ+e/7NFaBv59RAcElQu5mSRoHBWaQLJd2riJoAxjd/MeoPyZR2x29LAv63dbuV+/InBW+wc1Fo+AD+gvDIQYaDZqpPlqJjCAJKlw7S40JuggNNt+rN8qAfz81LpshWRCLg1ROtJggW8AiI34VqOWpA4dwmCxU/ra6ZKRqZ acutchin@aaronshell01.bitpushertest.com" ]
    },
    ##  CREATE /data DIRECTORY
    {
      path                              = "s3://${aws_s3_bucket.bootstrap.id}/${aws_s3_bucket_object.bootstrap_script_data_dir.key}"
      name                              = "data_dir"
    }
  ]

  tags                                  = "${local.tags_w_name}"

  service_role                          = "${aws_iam_role.iam_emr_service.arn}"
}
