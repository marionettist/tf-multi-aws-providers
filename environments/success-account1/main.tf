variable "aws_region"                   {}
variable "account1_aws_profile"         { description = "the AWS profile to use to access the tfstate file for the account1 vpc" }
variable "account1_state_bucket_name"   {}
variable "account1_state_bucket_key"    {}
variable "account2_aws_profile"         { description = "the AWS profile to use to access the tfstate file for the account2 vpc" }
variable "account2_state_bucket_name"   {}
variable "account2_state_bucket_key"    {}

data "terraform_remote_state" "account1" {
  backend = "s3"
  config {
      region  = "${var.aws_region}"
      profile = "${var.account1_aws_profile}"
      bucket  = "${var.account1_state_bucket_name}"
      key     = "${var.account1_state_bucket_key}"
  }
}

data "terraform_remote_state" "account2" {
  backend = "s3"
  config {
      region  = "${var.aws_region}"
      profile = "${var.account2_aws_profile}"
      bucket  = "${var.account2_state_bucket_name}"
      key     = "${var.account2_state_bucket_key}"
  }
}

provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.account1_aws_profile}"
}

resource "aws_vpc_peering_connection" "account1_gateway" {
    peer_owner_id   = "${data.terraform_remote_state.account2.aws_account_id}"
    peer_vpc_id     = "${data.terraform_remote_state.account2.vpc_id}"
    vpc_id          = "${data.terraform_remote_state.account1.vpc_id}"

    tags {
      Name = "tf-issue-debugging-route-table"
    }
}

module "account1_route" {
  source = "../../modules/peering_route"

  aws_region                  = "${var.aws_region}"
  aws_profile                 = "${var.account1_aws_profile}"
  route_table_id              = "${data.terraform_remote_state.account1.route_table_id}"
  destination_cidr_block      = "${data.terraform_remote_state.account2.vpc_cidr}"
  vpc_peering_connection_id   = "${aws_vpc_peering_connection.account1_gateway.id}"
}
