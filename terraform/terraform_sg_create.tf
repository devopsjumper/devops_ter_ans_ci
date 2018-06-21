#SG allow all default
resource "aws_security_group" "allow_all" {
  name        = "allow-all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#SG rdp private inbound only
#Would be restricted in real world
resource "aws_security_group" "rdp-private" {
  name        = "rdp-private"
  description = "rdp restricted"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["86.20.183.14/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#SG http inbound. Real world would be CDN IP address
resource "aws_security_group" "http-public" {
  name        = "http-public"
  description = "http public"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#SG https inbound. Real world would be CDN IP address
resource "aws_security_group" "https-public" {
  name       = "https-public"
  description = "https public"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#SG Backend RDP
#Would be internal private IP only to gain access to RDBMS cluster
resource "aws_security_group" "db-rdp" {
  name       = "db-rdp"
  description = "RDBMS rdp private"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["86.20.183.14/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#SG MSSQL 1433 backend to webservers
#Allows 1433 to be used between instances
resource "aws_security_group" "db-mssql" {
  name       = "db-mssql"
  description = "RDBMS rdp private"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["10.0.3.0/24"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#SG Allow webserver to backend
#Allows 1433 to be used between instances
resource "aws_security_group" "web-mssql" {
  name       = "web-mssql"
  description = "RDBMS rdp private"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
  }

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/24"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#SG allow ELB to talk to public subnets http az1
resource "aws_security_group" "pubsubaz1-http" {
  name        = "pubsubaz1-http"
  description = "Allow ELB to Pub Instances AZ1"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

#SG allow ELB to talk to public subnets http az2
resource "aws_security_group" "pubsubaz2-http" {
  name        = "pubsubaz2-http"
  description = "Allow ELB to Pub Instances AZ2"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.3.0/24"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
