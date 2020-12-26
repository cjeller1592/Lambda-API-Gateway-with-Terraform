#!/bin/bash

s3_bucket="terraform-serverless-1592"

echo "Destroying bucket ..."

aws s3 rb s3://$s3_bucket --force

echo "Done!"

echo "Destroying Terraform resources ..."

# Just adding dummy data to the variables (TODO: figure out how to make Terraform ignore vars when destroying)
terraform destroy \
        -var="app_version=" \
        -var="bucket_name="\
         --auto-approve