output "all_instances" { value = "${ concat(
  "${module.bastion.internal_cnames}",
) }" }
output "monitored_instances" { value = "${ concat(
  "${module.bastion.internal_cnames}",
) }" }
