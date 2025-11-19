resource "aws_vpc" "myce_vpc" { # 새로운 vpc를 만들겠다는 의미
    cidr_block = "10.0.0.0/16" #IPv4 CIDR Block
    enable_dns_hostnames = true # DNS Hostname 사용 옵션, 기본은 false
    tags = { Name = "myce_vpc"} #tag입력
}

# 서브넷 생성
# Public Subnet
resource "aws_subnet" "myce-main-public-1" {
    vpc_id = aws_vpc.myce_vpc.id # 위에서 생성한 vpc 별칭 입력
    cidr_block = "10.0.10.0/24" # IPv4 CIDR 블럭
    availability_zone = "ap-northeast-2c" # 가용영역 지정
    map_public_ip_on_launch = true # 퍼블리 IP자동 부여 설정
    tags = { Name = "myce-terra-main-public-1"} # 태그
}

resource "aws_subnet" "myce-main-public-2" {
    vpc_id = aws_vpc.myce_vpc.id # 위에서 생성한 vpc 별칭 입력
    cidr_block = "10.0.20.0/24" # IPv4 CIDR 블럭
    availability_zone = "ap-northeast-2a" # 가용영역 지정
    map_public_ip_on_launch = true # 퍼블리 IP자동 부여 설정
    tags = { Name = "myce-terra-main-public-2"} # 태그
}

# Private Subnet
resource "aws_subnet" "myce-main-private-1" {
    vpc_id = aws_vpc.myce_vpc.id # 위에서 생성한 vpc 별칭 입력
    cidr_block = "10.0.11.0/24" # IPv4 CIDR 블럭
    availability_zone = "ap-northeast-2c" # 가용영역 지정
    map_public_ip_on_launch = false # 퍼블리 IP자동 부여 x
    tags = { Name = "myce-terra-main-private-1"} # 태그
}

resource "aws_subnet" "myce-main-private-2" {
    vpc_id = aws_vpc.myce_vpc.id # 위에서 생성한 vpc 별칭 입력
    cidr_block = "10.0.22.0/24" # IPv4 CIDR 블럭
    availability_zone = "ap-northeast-2a" # 가용영역 지정
    map_public_ip_on_launch = false # 퍼블리 IP자동 부여 x
    tags = { Name = "myce-terra-main-private-2"} # 태그
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "myce-igw" {
    vpc_id = aws_vpc.myce_vpc.id #어느 VPC와 연결할 것인지 지정
    tags = { Name = "myce-terra-igw" } #태그 설정
}


# 라우팅 테이블 생성
resource "aws_route_table" "myce-public-rt" {
    vpc_id = aws_vpc.myce_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myce-igw.id
    }
    tags = { Name = "myce-terra-public-rt" }
} 

resource "aws_route_table" "myce-private-rt" {
    vpc_id = aws_vpc.myce_vpc.id
    # route {
    #     cidr_block = "0.0.0.0/0"
    # }
    tags = { Name = "myce-terra-private-rt"}
}


resource "aws_route_table_association" "myce-routing-public-ac" {
    for_each = {
      "pub1" = aws_subnet.myce-main-public-1.id
      "pub2" = aws_subnet.myce-main-public-2.id
    }
    subnet_id = each.value
    route_table_id = aws_route_table.myce-public-rt.id
}

resource "aws_route_table_association" "myce-routing-private-ac" {
    for_each = {
      "prv1" = aws_subnet.myce-main-private-1.id
      "prv2" = aws_subnet.myce-main-private-2.id
    }
    subnet_id = each.value
    route_table_id = aws_route_table.myce-private-rt.id
}
