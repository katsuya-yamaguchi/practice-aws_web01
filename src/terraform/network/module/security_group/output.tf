##################################################
# security group (web)
##################################################
output "security_group_alb" {
  value = aws_security_group.alb.id
}

output "security_group_web" {
  value = aws_security_group.web.id
}

##################################################
# security group (db)
##################################################
output "security_group_db" {
  value = aws_security_group.db.id
}

##################################################
# security group (bastion)
##################################################
output "security_group_bastion" {
  value = aws_security_group.bastion.id
}