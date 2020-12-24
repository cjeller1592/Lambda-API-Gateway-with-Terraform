# Configuring API Gateway REST API to provide access to the Lambda function

resource "aws_api_gateway_rest_api" "example" {
  name        = "ServerlessExample"
  description = "Terraform Serverless Application Example"
}

# All incoming requests to API Gateway must match with a configured resource and method in order to be handled

# Configured resource 
resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.example.id
   parent_id   = aws_api_gateway_rest_api.example.root_resource_id
# The special path_part value activates proxy behavior, which means that this resource will match any request path
   path_part   = "{proxy+}"
}

# Configured method 
resource "aws_api_gateway_method" "proxy" {
   rest_api_id   = aws_api_gateway_rest_api.example.id
   resource_id   = aws_api_gateway_resource.proxy.id
# This allows any request method to be used.
   http_method   = "ANY"
   authorization = "NONE"
}
# Taken together, this means that all incoming requests will match this resource

# This configuration specifies that requests to this method should be sent to the Lambda function defined earlier
resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = aws_api_gateway_rest_api.example.id
   resource_id = aws_api_gateway_method.proxy.resource_id
   http_method = aws_api_gateway_method.proxy.http_method
# This integration type causes API gateway to call into the API of another AWS service 
# In this case, it will call the AWS Lambda API to create an "invocation" of the Lambda function
   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.example.invoke_arn
}

# Unfortunately the proxy resource cannot match an empty path at the root of the API
# To handle that, a similar configuration must be applied to the root resource that is built in to the REST API object
resource "aws_api_gateway_method" "proxy_root" {
   rest_api_id   = aws_api_gateway_rest_api.example.id
   resource_id   = aws_api_gateway_rest_api.example.root_resource_id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
   rest_api_id = aws_api_gateway_rest_api.example.id
   resource_id = aws_api_gateway_method.proxy_root.resource_id
   http_method = aws_api_gateway_method.proxy_root.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.example.invoke_arn
}

# Finally, you need to create an API Gateway "deployment" in order to activate
# the configuration and expose the API at a URL that can be used for testing

resource "aws_api_gateway_deployment" "example" {
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.example.id
   stage_name  = "test"
}

output "base_url" {
    value = aws_api_gateway_deployment.example.invoke_url
}

