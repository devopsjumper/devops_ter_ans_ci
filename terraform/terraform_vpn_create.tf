#Create customer VPN
resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_customer_gateway" "priv_gateway" {
  bgp_asn    = 65000
  ip_address = "<public_IP_endpoint_here>"
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "main_vpn" {
  vpn_gateway_id      = "${aws_vpn_gateway.priv_gateway.id}"
  customer_gateway_id = "${aws_customer_gateway.customer_gateway.id}"
  type                = "ipsec.1"
  static_routes_only  = true
}
