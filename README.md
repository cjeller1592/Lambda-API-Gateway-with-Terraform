# Lambda & API Gateway with Terraform

This lab is an implementation of the [Serverless Applications with AWS Lambda and API Gateway tutorial](https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway).

It also includes a script that automates the processes outlined in the tutorial, including [updating the Lambda function version](https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway#a-new-version-of-the-lambda-function). 

The script takes one argument — the verison number of your Lambda function.

```
./lab.sh 1.0.1
```