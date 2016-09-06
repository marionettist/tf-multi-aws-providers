# AWS resource does not exist #

This repo shows an issue with terraform reporting that an AWS resource doesn't exist when it does.
This seems to happen when resources from different AWS accounts are managed in the same terraform environment using several instances of the aws provider.


The error reported is:
```
Error applying plan:

1 error(s) occurred:

* aws_route.route: Error creating route: InvalidRouteTableID.NotFound: The routeTable ID 'rtb-b9c48ddd' does not exist
        status code: 400, request id: a43155a6-ff6b-41fc-a0d9-9b4c59231959
```

Given AWS accounts account1 and account2 containing both vpc's and route tables, the intent was to create a vpc peering connection in account2 and update route tables in both account1 and account2 with new routes.

However, `plan` and `apply` fail, reporting the error above when the route table exists in the account specified.

Here's a description of how the repository is structured if you want to replicate the issue:
* `dependencies` contains 2 terraform environments used to populate remote states pulled by the main code
    * `account1`  basic resources created or referenced from AWS account account1. Run `terraform apply` and `enable_remote_state.bash` 
    * `account2`  basic resources created or referenced from AWS account account2. Run `terraform apply` and `enable_remote_state.bash`
* `environments` contains terraform environments associated with the issue: 1 replicating the issue and 2 running successfully and proving the existence of the AWS resource that is supposed to not exist     
    * `failure-both-accounts` reproduces the error. The vpc peering gateway is created in account1 and there's an attempt to create the route table in account2 via a terraform module being passed an AWS profile for account2. So this terraform environment has 2 instances of the aws provider: one for account1 and one for account2 
    * `success-account1` shows working code similar to the failing environment. It also contains 2 instances of the aws provider, but they both point to the same account (account1)
    * `success-account2` ditto for acccount2 and shows that the route table that is not supposed to exist indeed does exist
    
Tested with Terraform versions: 0.7.2 and 0.7.3 (64-bit) on Windows 7 Enterprise

