# Create a new load balancer classic elb multizone
resource "aws_elb" "web-public-elb" {
  name               = "web-public-elb"
  subnets = ["${aws_subnet.public_subnet_a.id}","${aws_subnet.public_subnet_b.id}"]
  security_groups = [
          "${aws_security_group.pubsubaz1-http.id}",
          "${aws_security_group.pubsubaz2-http.id}",
          "${aws_security_group.rdp-private.id}"
   ]

#This would normally be https with ssl_certificate_id attribute
  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"
    #ssl_certificate_id = "${aws_iam_server_certificate.mywebsitecert.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80/"
    interval            = 5
  }


#AZ1 instances to be added to ELB
  instances                   = ["${aws_instance.webaz1.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 300
  tags {
    Name = "web_public_elb_az1"

}

#AZ2 instances to be added to ELB
  instances                   = ["${aws_instance.webaz2.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 300
  tags {
    Name = "web_public_elb_az2"
  }
}



#This would be used to add certificate
#resource "aws_iam_server_certificate" "mywebsitecert" {
#  name_prefix      = "websitedotcom"
  #Location of file can be s3 source
#  certificate_#body = "${file("ca_pem.pem")}"
#  private_key      = "${file("priv_key.pem")}"

#  lifecycle {
#    create_before_destroy = true
#  }
#}
