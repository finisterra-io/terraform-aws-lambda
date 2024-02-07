data "aws_iam_role" "this" {
  count = var.enabled ? 1 : 0

  name = var.iam_role_name
}

resource "aws_lambda_function" "this" {
  count = var.enabled ? 1 : 0

  architectures                  = var.architectures
  description                    = var.description
  filename                       = var.filename
  function_name                  = var.function_name
  handler                        = var.handler
  image_uri                      = var.image_uri
  kms_key_arn                    = var.kms_key_arn
  layers                         = var.layers
  memory_size                    = var.memory_size
  package_type                   = var.package_type
  publish                        = var.publish
  reserved_concurrent_executions = var.reserved_concurrent_executions
  role                           = data.aws_iam_role.this[0].arn
  runtime                        = var.runtime
  s3_bucket                      = var.s3_bucket
  s3_key                         = var.s3_key
  s3_object_version              = var.s3_object_version
  source_code_hash               = var.source_code_hash
  tags                           = var.tags
  timeout                        = var.timeout

  dynamic "dead_letter_config" {
    for_each = try(length(var.dead_letter_config_target_arn), 0) > 0 ? [true] : []

    content {
      target_arn = var.dead_letter_config_target_arn
    }
  }

  dynamic "environment" {
    for_each = var.lambda_environment != null ? [var.lambda_environment] : []
    content {
      variables = environment.value.variables
    }
  }

  dynamic "image_config" {
    for_each = length(var.image_config) > 0 ? [true] : []
    content {
      command           = lookup(var.image_config, "command", null)
      entry_point       = lookup(var.image_config, "entry_point", null)
      working_directory = lookup(var.image_config, "working_directory", null)
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_config_mode != null ? [true] : []
    content {
      mode = var.tracing_config_mode
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config
    content {
      ipv6_allowed_for_dual_stack = vpc_config.value.ipv6_allowed_for_dual_stack
      security_group_ids          = [for sg_id in vpc_config.value.security_group_ids : sg_id == "default" ? data.aws_security_group.default[0].id : sg_id]
      subnet_ids                  = lookup(vpc_config.value, "subnet_names", null) != null ? data.aws_subnet.default[*].id : vpc_config.value.subnet_ids
    }
  }

  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage_size != null ? [var.ephemeral_storage_size] : []
    content {
      size = var.ephemeral_storage_size
    }
  }
}

data "aws_partition" "this" {
  count = var.enabled ? 1 : 0
}

data "aws_region" "this" {
  count = var.enabled ? 1 : 0
}

data "aws_caller_identity" "this" {
  count = var.enabled ? 1 : 0
}
