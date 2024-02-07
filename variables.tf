variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  type        = bool
  default     = true
}

variable "architectures" {
  type        = list(string)
  description = <<EOF
    Instruction set architecture for your Lambda function. Valid values are ["x86_64"] and ["arm64"].
    Default is ["x86_64"]. Removing this attribute, function's architecture stay the same.
  EOF
  default     = null
}

variable "description" {
  type        = string
  description = "Description of what the Lambda Function does."
  default     = null
}

variable "lambda_environment" {
  type = object({
    variables = map(string)
  })
  description = "Environment (e.g. env variables) configuration for the Lambda function enable you to dynamically pass settings to your function code and libraries."
  default     = null
}

variable "ephemeral_storage_size" {
  type        = number
  description = <<EOF
  The size of the Lambda function Ephemeral storage (/tmp) represented in MB.
  The minimum supported ephemeral_storage value defaults to 512MB and the maximum supported value is 10240MB.
  EOF
  default     = null
}

variable "filename" {
  type        = string
  description = "The path to the function's deployment package within the local filesystem. If defined, The s3_-prefixed options and image_uri cannot be used."
  default     = null
}

variable "function_name" {
  type        = string
  description = "Unique name for the Lambda Function."
}

variable "handler" {
  type        = string
  description = "The function entrypoint in your code."
  default     = null
}

variable "image_config" {
  type        = any
  description = <<EOF
  The Lambda OCI [image configurations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#image_config)
  block with three (optional) arguments:
  - *entry_point* - The ENTRYPOINT for the docker image (type `list(string)`).
  - *command* - The CMD for the docker image (type `list(string)`).
  - *working_directory* - The working directory for the docker image (type `string`).
  EOF
  default     = {}
}

variable "image_uri" {
  type        = string
  description = "The ECR image URI containing the function's deployment package. Conflicts with filename, s3_bucket, s3_key, and s3_object_version."
  default     = null
}

variable "kms_key_arn" {
  type        = string
  description = <<EOF
  Amazon Resource Name (ARN) of the AWS Key Management Service (KMS) key that is used to encrypt environment variables.
  If this configuration is not provided when environment variables are in use, AWS Lambda uses a default service key.
  If this configuration is provided when environment variables are not in use, the AWS Lambda API does not save this
  configuration and Terraform will show a perpetual difference of adding the key. To fix the perpetual difference,
  remove this configuration.
  EOF
  default     = ""
}

variable "layers" {
  type        = list(string)
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to the Lambda Function."
  default     = []
}

variable "memory_size" {
  type        = number
  description = "Amount of memory in MB the Lambda Function can use at runtime."
  default     = 128
}

variable "package_type" {
  type        = string
  description = "The Lambda deployment package type. Valid values are Zip and Image."
  default     = "Zip"
}

variable "publish" {
  type        = bool
  description = "Whether to publish creation/change as new Lambda Function Version."
  default     = false
}

variable "reserved_concurrent_executions" {
  type        = number
  description = "The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations."
  default     = -1
}

variable "runtime" {
  type        = string
  description = "The runtime environment for the Lambda function you are uploading."
  default     = null
}

variable "s3_bucket" {
  type        = string
  description = <<EOF
  The S3 bucket location containing the function's deployment package. Conflicts with filename and image_uri.
  This bucket must reside in the same AWS region where you are creating the Lambda function.
  EOF
  default     = null
}

variable "s3_key" {
  type        = string
  description = "The S3 key of an object containing the function's deployment package. Conflicts with filename and image_uri."
  default     = null
}

variable "s3_object_version" {
  type        = string
  description = "The object version containing the function's deployment package. Conflicts with filename and image_uri."
  default     = null
}

variable "source_code_hash" {
  type        = string
  description = <<EOF
  Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the package file specified with either
  filename or s3_key. The usual way to set this is filebase64sha256('file.zip') where 'file.zip' is the local filename
  of the lambda function source archive.
  EOF
  default     = ""
}

variable "timeout" {
  type        = number
  description = "The amount of time the Lambda Function has to run in seconds."
  default     = 3
}

variable "tracing_config_mode" {
  type        = string
  description = "Tracing config mode of the Lambda function. Can be either PassThrough or Active."
  default     = null
}

variable "vpc_config" {
  type = list(object({
    security_group_ids          = list(string)
    subnet_ids                  = list(string)
    subnet_names                = list(string)
    vpc_id                      = string
    vpc_name                    = string
    ipv6_allowed_for_dual_stack = bool
  }))
  description = <<EOF
  Provide this to allow your function to access your VPC (if both 'subnet_ids' and 'security_group_ids' are empty then
  vpc_config is considered to be empty or unset, see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html for details).
  EOF
  default     = []
}

variable "dead_letter_config_target_arn" {
  type        = string
  description = <<EOF
  ARN of an SNS topic or SQS queue to notify when an invocation fails. If this option is used, the function's IAM role
  must be granted suitable access to write to the target object, which means allowing either the sns:Publish or
  sqs:SendMessage action on this ARN, depending on which service is targeted."
  EOF
  default     = null
}

variable "iam_role_name" {
  type        = string
  description = "IAM role name attached to the Lambda Function."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}
