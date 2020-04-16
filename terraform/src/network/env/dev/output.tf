output "security_group_web" {
  value = module.security_group.security_group_web
}
output "subnet_id_private_web_a" {
  value = module.vpc.subnet_id_private_web_a
}
output "subnet_id_private_web_c" {
  value = module.vpc.subnet_id_private_web_c
}
