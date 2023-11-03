resource "aws_vpc" "jenkins_vps" {
    cidr_block = var.cidr_block
    tags = {
        Name = "jenkins_vpc"
    }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.jenkins_vps.id
    cidr_block = var.public_subnet_cidr_block
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true
    tags = {
        Name = "Public subnet"
    }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.jenkins_vps.id
  cidr_block = var.private_subnet_cidr_block
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
        Name = "Private subnet"
  }
}

resource "aws_eip" "jenkins_vpc_eip" {
    vpc = true

    tags = {
      Name = "Network EIP"
    }
}

resource "aws_internet_gateway" "jenkins_vpc-igw" {
    vpc_id = aws_vpc.jenkins_vps.id
    tags = {
        Name = "jenkins_vpc Internet Gateway"
    }
}

resource "aws_route_table" "jenkins_vpc-public_route_table" {
    vpc_id = aws_vpc.jenkins_vps.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.jenkins_vpc-igw.id
    }

    tags = {
      Name = "jenkins_vpc Public Route Table"
    }
}


resource "aws_route_table_association" "jenkins_vpc-public_subnet_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.jenkins_vpc-public_route_table.id

}

resource "aws_nat_gateway" "jenkins_vpc-nat_gateway" {
    allocation_id = aws_eip.jenkins_vpc_eip.id
    subnet_id = aws_subnet.public_subnet.id
    tags = {
        Name = "jenkins_vpc NAT Gateway"
    }
}

resource "aws_route_table" "jenkins_vpc-private_route_table" {
  vpc_id = aws_vpc.jenkins_vps.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.jenkins_vpc-nat_gateway.id
  }

    tags = {
        Name = "jenkins_vpc Private Route Table"
    }
}

resource "aws_route_table_association" "jenkins_vpc-private_subnet_association" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.jenkins_vpc-private_route_table.id

}

output "ec2_public_ip" {
    value = aws_eip.jenkins_vpc_eip.public_ip
}
