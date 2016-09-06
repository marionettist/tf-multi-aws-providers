variable "aws_region" {}
variable "account2_aws_profile" {}
variable "account2_vpc_id" {}
variable "account2_vpc_cidr" {}
variable "account2_aws_account_id" {}

provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.account2_aws_profile}"
}

resource "aws_route_table" "table" {
  vpc_id = "${var.account2_vpc_id}"

  tags      { Name = "tf-issue-debugging-route-table" }
}

output "route_table_id" { value = "${aws_route_table.table.id}"}
output "vpc_cidr" { value = "${var.account2_vpc_cidr}"}
output "aws_account_id" { value = "${var.account2_aws_account_id}"}
output "vpc_id" { value = "${var.account2_vpc_id}"}
