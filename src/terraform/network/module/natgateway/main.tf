variable "env" {}
variable "internet_gateway" {}
variable "subnet_id_public_a" {}
variable "subnet_id_public_c" {}
variable "route_table_id_public_a" {}
variable "route_table_id_public_c" {}
variable "route_table_id_private_web_a" {}
variable "route_table_id_private_web_c" {}



##################################################
# EIP for NATGateway
##################################################
resource "aws_eip" "ngw_public_a" {
  vpc = true
  depends_on = [
    var.internet_gateway
  ]
  tags = {
    Name = "public_a"
    Env  = var.env
  }
}

resource "aws_eip" "ngw_public_c" {
  vpc = true
  depends_on = [
    var.internet_gateway
  ]
  tags = {
    Name = "public_c"
    Env  = var.env
  }
}

##################################################
# NATGateway
##################################################
resource "aws_nat_gateway" "public_a" {
  allocation_id = aws_eip.ngw_public_a.id
  subnet_id     = var.subnet_id_public_a
  tags = {
    Name = "public_a"
    Env  = var.env
  }
}

resource "aws_nat_gateway" "public_c" {
  allocation_id = aws_eip.ngw_public_c.id
  subnet_id     = var.subnet_id_public_c
  tags = {
    Name = "public_c"
    Env  = var.env
  }
}

##################################################
# Route
##################################################
resource "aws_route" "public_a" {
  route_table_id         = var.route_table_id_public_a
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public_a.id
}

resource "aws_route" "public_c" {
  route_table_id         = var.route_table_id_public_c
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public_c.id
}

resource "aws_route" "private_web_a" {
  route_table_id         = var.route_table_id_private_web_a
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public_a.id
}

resource "aws_route" "private_web_c" {
  route_table_id         = var.route_table_id_private_web_c
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public_c.id
}
