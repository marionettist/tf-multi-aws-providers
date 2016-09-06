#!/bin/bash

terraform remote config \
  -backend S3 \
  -backend-config="bucket=tf-issue-state-account1" \
  -backend-config="key=account1-dependencies.tfstate" \
  -backend-config="region=eu-west-1" \
  -backend-config="profile=${TF_VAR_account1_aws_profile}"
