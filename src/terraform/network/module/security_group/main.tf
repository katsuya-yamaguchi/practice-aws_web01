variable "env" {}
variable "vpc_id" {}

##################################################
# security group (ALB)
##################################################
resource "aws_security_group" "alb" {
  name                   = "alb"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = false

  tags = {
    Name = "alb"
    Env  = var.env
  }
}

resource "aws_security_group_rule" "alb_permit_from_internet_http" {
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "permit from internet for http."
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "80"
  to_port           = "80"
}

resource "aws_security_group_rule" "alb_permit_from_internet_https" {
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "permit from internet for https."
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "443"
  to_port           = "443"
}

resource "aws_security_group_rule" "alb_permit_to_web" {
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = aws_security_group.web.id
  description              = "permit to web."
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = "80"
  to_port                  = "80"
}

##################################################
# security group (web)
##################################################
resource "aws_security_group" "web" {
  name                   = "web"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = false

  tags = {
    Name = "web"
    Env  = var.env
  }
}

resource "aws_security_group_rule" "web_permit_from_alb" {
  security_group_id        = aws_security_group.web.id
  source_security_group_id = aws_security_group.alb.id
  description              = "permit from alb."
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "80"
  to_port                  = "80"
}

resource "aws_security_group_rule" "web_permit_from_bastion" {
  security_group_id        = aws_security_group.web.id
  source_security_group_id = aws_security_group.bastion.id
  description              = "permit from bastion."
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "22"
  to_port                  = "22"
}

resource "aws_security_group_rule" "web_permit_to_db" {
  security_group_id        = aws_security_group.web.id
  source_security_group_id = aws_security_group.db.id
  description              = "permit to db."
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = "3306"
  to_port                  = "3306"
}

##################################################
# security group (db)
##################################################
resource "aws_security_group" "db" {
  name                   = "db"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = false

  tags = {
    Name = "db"
    Env  = var.env
  }
}

resource "aws_security_group_rule" "db_permit_from_web" {
  security_group_id        = aws_security_group.db.id
  source_security_group_id = aws_security_group.web.id
  description              = "permit from web."
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "3306"
  to_port                  = "3306"
}

##################################################
# security group (bastion)
##################################################
resource "aws_security_group" "bastion" {
  name                   = "bastion"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = false

  tags = {
    Name = "bastion"
    Env  = var.env
  }
}

resource "aws_security_group_rule" "bastion_permit_from_ssh" {
  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "permit from ssh."
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "22"
  to_port           = "22"
}

# resource "aws_security_group_rule" "bastion_permit_to_web" {
#   security_group_id        = aws_security_group.bastion.id
#   source_security_group_id = aws_security_group.web.id
#   description              = "permit to web."
#   type                     = "egress"
#   protocol                 = "tcp"
#   from_port                = "22"
#   to_port                  = "22"
# }

resource "aws_security_group_rule" "bastion_permit_to_internet" {
  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "permit to internet."
  type              = "egress"
  protocol          = "-1"
  from_port         = "0"
  to_port           = "0"
}