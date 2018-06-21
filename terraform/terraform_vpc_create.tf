#Create VPC
#Including NAT gateways for private subnets to connect to through IGW
#Including routing being published to route tables


resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags {
    Name = "main"
  }
}

#Subnet Creation
#Public subnet in AZ1
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false

  tags {
    Name = "web_public_az1"
  }
}

#Private subnet in AZ1
resource "aws_subnet" "private_subnet_a" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-1a"

  tags {
    Name = "web_private_az1"
  }
}

#Public subnet in AZ2
resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = false

  tags {
    Name = "web_public_az2"
  }
}

#Private subnet in AZ2
resource "aws_subnet" "private_subnet_b" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "eu-west-1b"

  tags {
    Name = "web_private_az2"
  }
}


#AWS Gateway association
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.main.id}"
}

#AWS Public Routetable
resource "aws_route_table" "public_routetable" {
  vpc_id = "${aws_vpc.main.id}"

#AWS IGW allow all
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }

  tags {
    label = "main"
  }
}


#Associate Public Subnets with routetable
#Public subnet az1
resource "aws_route_table_association" "public_subnet_a" {
  subnet_id      = "${aws_subnet.public_subnet_a.id}"
  route_table_id = "${aws_route_table.public_routetable.id}"
}

#Public subnet az2
resource "aws_route_table_association" "public_subnet_b" {
  subnet_id      = "${aws_subnet.public_subnet_b.id}"
  route_table_id = "${aws_route_table.public_routetable.id}"
}


#Nat gateway creation multizone AZ1
resource "aws_eip" "priv_nat_a" {
  vpc = true
}

resource "aws_nat_gateway" "priv_nat_a" {
  allocation_id = "${aws_eip.priv_nat_a.id}"
  subnet_id     = "${aws_subnet.public_subnet_a.id}"
}

resource "aws_route_table" "private_routetable_a" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.priv_nat_a.id}"
  }

  tags {
    label = "main"
  }
}

resource "aws_route_table_association" "private_subnet_a" {
  subnet_id      = "${aws_subnet.private_subnet_a.id}"
  route_table_id = "${aws_route_table.private_routetable_a.id}"
}


#Nat gateway creation multizone AZ2
resource "aws_eip" "priv_nat_b" {
  vpc = true
}

resource "aws_nat_gateway" "priv_nat_b" {
  allocation_id = "${aws_eip.priv_nat_b.id}"
  subnet_id     = "${aws_subnet.public_subnet_b.id}"
}

resource "aws_route_table" "private_routetable_b" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.priv_nat_b.id}"
  }

  tags {
    label = "main"
  }
}

resource "aws_route_table_association" "private_subnet_b" {
  subnet_id      = "${aws_subnet.private_subnet_b.id}"
  route_table_id = "${aws_route_table.private_routetable_b.id}"
}
