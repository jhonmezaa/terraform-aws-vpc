################################################################################
# VPC Flow Logs
################################################################################

################################################################################
# CloudWatch Logs
################################################################################

# CloudWatch Log Group for Flow Logs
resource "aws_cloudwatch_log_group" "flow_log" {
  count = local.create_flow_log_cloudwatch_log_group ? 1 : 0

  name              = local.flow_log_cloudwatch_log_group_name
  retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  kms_key_id        = var.flow_log_cloudwatch_log_group_kms_key_id

  tags = merge(
    {
      Name = local.flow_log_cloudwatch_log_group_name
    },
    local.common_tags,
    var.flow_log_cloudwatch_log_group_tags
  )
}

# IAM Role for Flow Logs to CloudWatch
data "aws_iam_policy_document" "flow_log_cloudwatch_assume_role" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  statement {
    sid = "AWSVPCFlowLogsAssumeRole"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "flow_log_cloudwatch" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  name               = local.flow_log_cloudwatch_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.flow_log_cloudwatch_assume_role[0].json

  tags = merge(
    {
      Name = local.flow_log_cloudwatch_iam_role_name
    },
    local.common_tags,
    var.flow_log_cloudwatch_iam_role_tags
  )
}

data "aws_iam_policy_document" "flow_log_cloudwatch" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  statement {
    sid = "AWSVPCFlowLogsPushToCloudWatch"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "flow_log_cloudwatch" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  name   = "vpc-flow-logs-policy"
  role   = aws_iam_role.flow_log_cloudwatch[0].id
  policy = data.aws_iam_policy_document.flow_log_cloudwatch[0].json
}

################################################################################
# VPC Flow Log Resource
################################################################################

resource "aws_flow_log" "this" {
  count = local.enable_flow_log ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  # Traffic type
  traffic_type = var.flow_log_traffic_type

  # Destination configuration
  log_destination_type = var.flow_log_destination_type
  log_destination = var.flow_log_destination_type == "cloud-watch-logs" ? (
    var.flow_log_cloudwatch_log_group_arn != null ? var.flow_log_cloudwatch_log_group_arn : aws_cloudwatch_log_group.flow_log[0].arn
  ) : var.flow_log_destination_arn

  # IAM role for CloudWatch Logs
  iam_role_arn = var.flow_log_destination_type == "cloud-watch-logs" ? (
    var.flow_log_cloudwatch_iam_role_arn != null ? var.flow_log_cloudwatch_iam_role_arn : aws_iam_role.flow_log_cloudwatch[0].arn
  ) : null

  # Log format
  log_format = var.flow_log_log_format

  # File format (for S3 and Kinesis Firehose only - not supported for CloudWatch Logs)
  dynamic "destination_options" {
    for_each = var.flow_log_destination_type == "s3" ? [1] : []

    content {
      file_format                = var.flow_log_file_format
      hive_compatible_partitions = var.flow_log_hive_compatible_partitions
      per_hour_partition         = var.flow_log_per_hour_partition
    }
  }

  # Maximum aggregation interval
  max_aggregation_interval = var.flow_log_max_aggregation_interval

  tags = merge(
    {
      Name = "${local.vpc_name}-flow-log"
    },
    local.common_tags,
    var.flow_log_tags
  )
}
