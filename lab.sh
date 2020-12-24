#!/bin/bash

s3_bucket="terraform-serverless-1592"

bucketstatus=$(aws s3api head-bucket --bucket "${s3_bucket}" 2>&1)

if echo "${bucketstatus}" | grep 'Not Found';
then
  echo "Bucket doesn't exist. Creating ..."
  aws s3api create-bucket --bucket=$(s3_bucket) --region=us-east-1
  echo "Done!";

elif echo "${bucketstatus}" | grep 'Forbidden';
then
  echo "Bucket exists but not owned. Find another name for a bucket!"

elif echo "${bucketstatus}" | grep 'Bad Request';
then
  echo "Bucket name specified is less than 3 or greater than 63 characters. Find another name for a bucket!"

else
  echo "Bucket owned and exists. Continuing on!";
fi

echo "Zipping function ..."

cd example

zip ../example.zip main.js

cd ..

echo "Done!"

aws s3 cp example.zip s3://$s3_bucket/v$1/example.zip

terraform init

terraform apply \
 -var="app_version=$1" \
 -var="bucket_name=$s3_bucket"\
 --auto-approve

