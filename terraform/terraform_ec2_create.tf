#Create public webservers
resource "aws_instance" "webaz1" {
  ami           = "ami-894c7bf0"
  instance_type = "t2.micro"
  count = 2
  key_name = "autoone"
  availability_zone = "eu-west-1a"
  subnet_id = "${aws_subnet.public_subnet_a.id}"
  vpc_security_group_ids = [
          "${aws_security_group.rdp-private.id}",
          "${aws_security_group.http-public.id}",
          "${aws_security_group.https-public.id}",
          "${aws_security_group.web-mssql.id}"
      ]
  tags {
  Name = "Webaz1"
  }
}

resource "aws_instance" "webaz2" {
  ami           = "ami-894c7bf0"
  instance_type = "t2.micro"
  count = 2
  key_name = "autoone"
  availability_zone = "eu-west-1b"
  subnet_id = "${aws_subnet.public_subnet_b.id}"
  vpc_security_group_ids = [
          "${aws_security_group.rdp-private.id}",
          "${aws_security_group.http-public.id}",
          "${aws_security_group.https-public.id}",
          "${aws_security_group.web-mssql.id}"
      ]
  tags {
  Name = "Webaz2"
  }
}

#Create private backend webservers
resource "aws_instance" "dbaz1" {
  ami           = "ami-894c7bf0"
  instance_type = "t2.micro"
  count = 1
  key_name = "autoone"
  availability_zone = "eu-west-1a"
  subnet_id = "${aws_subnet.private_subnet_a.id}"
  vpc_security_group_ids = [
          "${aws_security_group.db-rdp.id}",
          "${aws_security_group.db-mssql.id}"
      ]
  tags {
  Name = "rdbaz1"
  }
}

#Create private backend webservers
resource "aws_instance" "dbaz2" {
  ami           = "ami-894c7bf0"
  instance_type = "t2.micro"
  count = 1
  key_name = "autoone"
  availability_zone = "eu-west-1b"
  subnet_id = "${aws_subnet.private_subnet_b.id}"
  vpc_security_group_ids = [
          "${aws_security_group.db-rdp.id}",
          "${aws_security_group.db-mysql.id}"
      ]
  tags {
  Name = "rdbaz2"
  }
}



#---------------------Further Notes ----------------------------
#The way id do it in real world with interpolation using one resource block using element wrapper,
#at present to many errors to debug given time
#1a var for ec2 creation
#variable "availability_zones" {
#     default = "eu-west-1a,eu-west-1b"
#     description = "The AZ's where resources are created"
#}

#1b var for ec2 creation
#variable "subnet_ids" {
#  default =  ["sub_a", "sub_b"]
#}

#resource "aws_instance" "weba" {
#  ami           = "ami-894c7bf0"
#  instance_type = "t2.micro"
#  count = 2
#  key_name = "autoone"

  #Can use with interpolation, examples:
  #availability_zone = "${element(split(",",var.availability_zones),count.index)}"
  #Had a play with strings and lists using count
  #subnet_id = "${element(split(",",var.subnet_ids),count.index)}"
  #subnet_id = "${element(list("${aws_subnet.sub-a.id}", "${aws_subnet.sub-b.id}"), count.index)}"
#  vpc_security_group_ids = [
#          "${aws_security_group.webrdp.id}"
#      ]
#  tags {
#  Name = "Web"
#  }
#}
