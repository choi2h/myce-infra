# 보안그룹 생성
resource "aws_security_group" "myce_sg_nat" {
    name = "myce_sg_nat"
    vpc_id = var.vpc_id
}

locals {
    default_nat_sg_id = aws_security_group.myce_sg_nat.id
}

resource "aws_security_group_rule" "myce_sg_nat_ingress_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = local.default_nat_sg_id
}

resource "aws_security_group_rule" "myce_sg_nat_egress_all" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1" # 모든 프로토콜을 의미
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = local.default_nat_sg_id
}