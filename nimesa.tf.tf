provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2" {
    ami = "ami-0b0dcb5067f052a63"
    instance_type = "t2.micro"
   // security_groups = ["rtp03-sg"]
   vpc_security_group_ids = ["${aws_security_group.sg.id}"]
   subnet_id = "${aws_subnet.public_subent_01.id}"
}

resource "aws_ebs_volume" "assignment" {
  availability_zone = "us-east-1a"
  size              = 8
  type              = "gp2"
  tags = {
    Name = "assignment"
  }

}
resource "aws_security_group" "sg" {
    name = "sg"
    vpc_id = "${aws_vpc.assinement.id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ssh-sg"

    }

}

//creating a VPC
resource "aws_vpc" "assinement" {
   instance_tenancy = "default"
   enable_dns_support   ="true"
   enable_dns_hostnames ="true"
   cidr_block = "192.168.0.0/24"
    tags = {
      Name = "assinement"
        }
  
}

// Creatomg a public Subnet 
resource "aws_subnet" "public_subent_01" {
    vpc_id = "${aws_vpc.assinement.id}"
    cidr_block = "192.168.0.0/25"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      Name = "public_subent_01"
    }
  
}
// Creatomg a private Subnet 
resource "aws_subnet" "private_subent_01" {
    vpc_id = "${aws_vpc.assinement.id}"
    cidr_block = "192.168.0.128/25"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1d"
    tags = {
      Name = "private_subent_01"
    }
  
}
//Creating a Internet Gateway 
resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.assinement.id}"
    tags = {
      Name = "igw"
    }
}

// Create a public route table 
resource "aws_route_table" "public-rt" {
    vpc_id = "${aws_vpc.assinement.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
    tags = {
      Name = "public-rt"
    }
}
// Create a private route table 
resource "aws_route_table" "private-rt" {
    vpc_id = "${aws_vpc.assinement.id}"
    tags = {
      Name = "private-rt"
    }
}
// Associate subnet with routetable 

resource "aws_route_table_association" "public-subent-1" {
    subnet_id = "${aws_subnet.public_subent_01.id}"
    route_table_id = "${aws_route_table.public-rt.id}"
  
}
resource "aws_route_table_association" "rivate-subent-1" {
    subnet_id = "${aws_subnet.public_subent_01.id}"
    route_table_id = "${aws_route_table.private-rt.id}"
  
}