locals {
    default_keypair_id = aws_key_pair.myce_keypair.id
    project_name = "myce-terra"
}

# vpc & subnet 생성
module "myce_vpc" {
    source = "./modules/vpc"
    name_prefix = local.project_name
    vpc_cidr = "10.0.0.0/16"
    public_subnets = {
        public-1: {
            cidr = "10.0.10.0/24",
            availability_zone = "ap-northeast-2a"
        },
        public-2: {
            cidr = "10.0.20.0/24"
            availability_zone = "ap-northeast-2c"
        }
    }
    private_subnets = {
        private-1: {
            cidr = "10.0.11.0/24",
            availability_zone = "ap-northeast-2a"
        },
        private-2: {
            cidr = "10.0.22.0/24"
            availability_zone = "ap-northeast-2c"
        }
    }
    route_cidr = "0.0.0.0/0"
}

# security group 생성
module "sg_groups" {
    source = "./modules/security_groups"
    vpc_id = module.myce_vpc.vpc_id
    name_prefix = local.project_name
}

# EC2 생성
module "myce_public_instance" {
    source = "./modules/ec2-instance"
    key_pair_id = local.default_keypair_id
    subnet_ids = {
        public: module.myce_vpc.public_subnet_ids["public-1"],
        private: module.myce_vpc.private_subnet_ids["private-1"], 
        nat: module.myce_vpc.public_subnet_ids["public-1"],
        bastion: module.myce_vpc.public_subnet_ids["public-2"]
    }
    security_goups = {
        public: [ module.sg_groups.public_sg_id ] ,
        private: [ module.sg_groups.private_sg_id ],
        nat: [ module.sg_groups.nat_sg_id ],
        bastion: [ module.sg_groups.bastion_sg_id ]
    } 
    name_prefix = local.project_name
}
