##  BOOTSTRAP SCRIPT BUCKET
resource "aws_s3_bucket" "bootstrap" {
  bucket          = "${local.org-env-name}-bootstrap"
  acl             = "private"
  tags            = "${ merge( var.tags, map( "Name", "${local.org-env-name}-bootstrap" ) ) }"
  force_destroy   = "true"
}

#####################################################
##
##  BOOTSTRAP SCRIPTS
##
##  THESE SCRIPTS END UP IN /emr/instance-controller/lib/bootstrap-actions/X/
##
##  STDOUT AND STDERR FOR THESE SCRIPTS ARE IN: /emr/instance-controller/log/bootstrap-actions/X/

##  INSTALL YUM PACKAGES
resource "aws_s3_bucket_object" "bootstrap_script_install_yum_packages" {
  bucket          = "${aws_s3_bucket.bootstrap.id}"
  key             = "install_yum_packages.sh"
  content         = "${file("${path.module}/bootstrap.install_yum_packages.sh")}"
}

##  INSTALL HADOOP USER SSH PUB KEY
resource "aws_s3_bucket_object" "bootstrap_script_hadoop_ssh_pub_key" {
  bucket          = "${aws_s3_bucket.bootstrap.id}"
  key             = "hadoop_ssh_pub_key.sh"
  content         = "${file("${path.module}/bootstrap.hadoop_ssh_pub_key.sh")}"
}

##  DATA DIR
resource "aws_s3_bucket_object" "bootstrap_script_data_dir" {
  bucket          = "${aws_s3_bucket.bootstrap.id}"
  key             = "data_dir.sh"
  content         = "${file("${path.module}/bootstrap.data_dir.sh")}"
}
