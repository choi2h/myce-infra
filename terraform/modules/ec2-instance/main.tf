# EC2 생성
resource "aws_instance" "this" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_pair_id
    subnet_id = var.subnet_id
    vpc_security_group_ids = var.security_goups
    associate_public_ip_address = var.use_public_ip
    tags = { Name = var.name } 
}