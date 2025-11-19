locals {
    default_keypair_id = aws_key_pair.myce_keypair.id
}

module "sg_groups" {
    source = "./modules/security_groups"
    vpc_id = aws_vpc.myce_vpc.id
}

# EC2 생성
module "myce_public_instance" {
    source = "./modules/ec2-instance"
    key_pair_id = local.default_keypair_id
    subnet_id = aws_subnet.myce-main-public-2.id
    security_goups = [ module.sg_groups.public_sg_id ]
    name = "myce-main-public"
}

module "myce_nat_instance" {
    source = "./modules/ec2-instance"
    key_pair_id = local.default_keypair_id
    subnet_id = aws_subnet.myce-main-public-2.id
    security_goups = [ module.sg_groups.nat_sg_id ]
    name = "myce-main-nat"
}

module "myce_bastion_instance" {
    source = "./modules/ec2-instance"
    key_pair_id = local.default_keypair_id
    subnet_id = aws_subnet.myce-main-public-1.id
    security_goups = [ module.sg_groups.bastion_sg_id ]
    name = "myce-main-bastion"
}

module "myce_private_instance" {
    source = "./modules/ec2-instance"
    key_pair_id = local.default_keypair_id
    subnet_id = aws_subnet.myce-main-private-1.id
    security_goups = [ module.sg_groups.private_sg_id ]
    use_public_ip = false
    name = "myce-main-private"
}