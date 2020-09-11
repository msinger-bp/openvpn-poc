output "org"                { value = "${var.org}" }
output "primary_aws_region" { value = "${var.primary_aws_region}" }
output "vpc-main_az_list"   { value = "${var.vpc-main_az_list}" }
output "frontend_redis"     { value = "${redis_primary_endpoint}" }
