variable "aws_region"                   {}
variable "aws_profile"                  {}
variable "route_table_id"               {}
variable "destination_cidr_block"       {}
variable "vpc_peering_connection_id"    {}

provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

resource "aws_route" "route" {
  route_table_id            = "${var.route_table_id}"
  destination_cidr_block    = "${var.destination_cidr_block}"
  vpc_peering_connection_id = "${var.vpc_peering_connection_id}"
}
