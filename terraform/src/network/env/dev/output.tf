output "security_group_alb" {
  value = module.security_group.security_group_alb
}
output "security_group_web" {
  value = module.security_group.security_group_web
}
output "security_group_bastion" {
  value = module.security_group.security_group_bastion
}
output "subnet_id_private_web_a" {
  value = module.vpc.subnet_id_private_web_a
}
output "subnet_id_private_web_c" {
  value = module.vpc.subnet_id_private_web_c
}
output "subnet_id_public_a" {
  value = module.vpc.subnet_id_public_a
}
output "subnet_id_public_c" {
  value = module.vpc.subnet_id_public_c
}
