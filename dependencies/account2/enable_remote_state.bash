#!/bin/bash

terraform remote config \
  -backend S3 \
  -backend-config="bucket=tf-issue-state-account2" \
  -backend-config="key=account2-dependencies.tfstate" \
  -backend-config="region=eu-west-1" \
  -backend-config="profile=${TF_VAR_account2_aws_profile}"
