##################################################
# security group (web)
##################################################
output "security_group_web" {
  value = aws_security_group.web.id
}
