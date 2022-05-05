# Taken from https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions

locals {
  bucket-name = "lb-logs-${var.label}"
}

data "aws_partition" "current" {}

data "aws_elb_service_account" "default" {}

resource "aws_s3_bucket" "lb_access_logs" {
  bucket        = local.bucket-name
  force_destroy = true

  tags = merge(var.tags, { "Name" : "${local.bucket-name}" })
}

resource "aws_s3_bucket_acl" "lb_access_logs" {
  bucket = aws_s3_bucket.lb_access_logs.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "lb_access_logs" {
  bucket = aws_s3_bucket.lb_access_logs.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${join("", data.aws_elb_service_account.default.*.arn)}"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:${data.aws_partition.current.partition}:s3:::${local.bucket-name}/*"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:${data.aws_partition.current.partition}:s3:::${local.bucket-name}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:${data.aws_partition.current.partition}:s3:::${local.bucket-name}"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_lifecycle_configuration" "lb_access_logs" {
  bucket = aws_s3_bucket.lb_access_logs.id

  rule {
    id     = "lbAccessLogs"
    status = "Enabled"
    expiration {
      days = var.lb_log_retention_in_days
    }
  }
}
