# ---------------------------------------------------------------------------------------------------------------------
### Source Account
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  alias  = "source"
  region = var.src_aws_region
}

provider "aws" {
  alias  = "destination"
  region = var.dst_aws_region
}

# ---------------------------------------------------------------------------------------------------------------------
# src bucket
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "src_s3" {
  count                 = var.is_src_account && var.src_create_s3_bucket ? 1 : 0
  bucket                = var.src_s3_bucket_name
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  count                 = var.is_src_account && var.src_create_s3_bucket ? 1 : 0
  depends_on            = [aws_s3_bucket.src_s3]
  bucket                = aws_s3_bucket.src_s3[0].id
  rule {
    object_ownership    = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "src_pb" {
  count                   = var.is_src_account && var.src_create_s3_bucket ? 1 : 0
  depends_on              = [aws_s3_bucket.src_s3]
  bucket                  = aws_s3_bucket.src_s3[0].id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "src_acl" {
  count                   = var.is_src_account && var.src_create_s3_bucket ? 1 : 0
  depends_on              = [aws_s3_bucket_ownership_controls.ownership]
  bucket                  = aws_s3_bucket.src_s3[0].id
  acl                     = "private"
}

# ---------------------------------------------------------------------------------------------------------------------
# src role
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "src_role" {
  count                 = var.is_src_account && var.src_create_iam_role ? 1 : 0
  name                  = var.src_create_iam_role != null ? var.src_iam_role_name : null
  name_prefix           = var.src_iam_role_name != null ? null : "src-datasync"
  description           = "DataSync IAM Role"
  assume_role_policy    = data.aws_iam_policy_document.datasync_assume.json
  force_detach_policies = var.src_force_detach_policies
  permissions_boundary  = var.src_iam_role_permissions_boundary
  tags = var.tags
}

resource "aws_iam_role_policy" "src_policy" {
  count                 = var.is_src_account && var.src_create_iam_role ? 1 : 0
  name_prefix           = "datasync"
  role                  = aws_iam_role.src_role[0].id
  policy                = data.aws_iam_policy_document.src_datasync.json
}

# ---------------------------------------------------------------------------------------------------------------------
### Destination Account
# ---------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------
# dst bucket
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "dst_s3" {
  count                   = var.dst_create_s3_bucket && !var.is_src_account ? 1 : 0
  bucket                  = var.dst_s3_bucket_name
  policy                  = var.dst_s3_attach_custom_policy ? jsonencode( var.dst_s3_custom_policy ) : data.aws_iam_policy_document.dst_s3_attached_policy.json
}

resource "aws_s3_bucket_ownership_controls" "dst_ownership" {
  count                   = var.dst_create_s3_bucket && !var.is_src_account ? 1 : 0
  depends_on              = [aws_s3_bucket.dst_s3]
  bucket                  = aws_s3_bucket.dst_s3[0].id
  rule {
    object_ownership      = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "dst_pb" {
  count                   = var.dst_create_s3_bucket && !var.is_src_account ? 1 : 0
  depends_on              = [aws_s3_bucket.dst_s3]
  bucket                  = aws_s3_bucket.dst_s3[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "dst_acl" {
  count                   = var.dst_create_s3_bucket && !var.is_src_account ? 1 : 0
  depends_on              = [aws_s3_bucket_ownership_controls.dst_ownership]
  bucket                  = aws_s3_bucket.dst_s3[0].id
  acl                     = "private"
}

# ---------------------------------------------------------------------------------------------------------------------
# Datasync Task
# ---------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------
# locations (always use the source role)
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_datasync_location_s3" "src_s3" {
  count             = var.task_create ? 1 : 0
  provider          = aws.source
  s3_bucket_arn     = try(length(var.src_s3_bucket_arn), 0) > 0 ? var.src_s3_bucket_arn : aws_s3_bucket.src_s3[0].arn 
  subdirectory      = try(length(var.src_s3_bucket_path), 0) > 0 ? var.src_s3_bucket_path : "/"

  s3_config {
    bucket_access_role_arn = try(length(var.src_iam_role_arn), 0) > 0 ? var.src_iam_role_arn : aws_iam_role.src_role[0].arn
  }
}

resource "aws_datasync_location_s3" "dst_s3" {
  count             = var.task_create ? 1 : 0
  provider          = aws.destination
  s3_bucket_arn     = try(length(var.dst_s3_bucket_arn), 0) > 0 ? var.dst_s3_bucket_arn : aws_s3_bucket.dst_s3[0].arn 
  subdirectory      = try(length(var.dst_s3_bucket_path), 0) > 0 ? var.dst_s3_bucket_path : "/"

  s3_config {
    bucket_access_role_arn = try(length(var.src_iam_role_arn), 0) > 0 ? var.src_iam_role_arn : aws_iam_role.src_role[0].arn
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# task
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_datasync_task" "this" {
  count                    = var.task_create ? 1 : 0
  name                     = try(length(var.task_name), 0) > 0 ? var.task_name : "example-task"
  destination_location_arn = aws_datasync_location_s3.dst_s3[0].arn
  source_location_arn      = aws_datasync_location_s3.src_s3[0].arn
  
  options {
    bytes_per_second  = -1
    posix_permissions = "NONE"
    uid               = "NONE"
    gid               = "NONE"
    verify_mode       = "NONE"
  }

  schedule {
    schedule_expression = var.task_schedule
  }
}
