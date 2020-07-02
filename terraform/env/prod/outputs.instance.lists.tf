output "all_instances" { value = "${ concat(
  "${module.bastion.internal_cnames}",
  "${module.frontend.internal_cnames}",
  "${module.monitoring.internal_cnames}",
) }" }
output "monitored_instances" { value = "${ concat(
  "${module.bastion.internal_cnames}",
  "${module.frontend.internal_cnames}",
) }" }
output "docker_instances" { value = "${ concat(
  "${module.frontend.internal_cnames}",
  "${module.monitoring.internal_cnames}",
) }" }
