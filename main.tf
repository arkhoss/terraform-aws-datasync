# ---------------------------------------------------------------------------------------------------------------------
### Source S3
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "s3" {
  count                 = var.is_src_account && var.src_create_s3_bucket ? 1 : 0
  bucket                = var.src_s3_bucket_name
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  count                 = var.is_src_account && var.src_create_s3_bucket ? 1 : 0
  depends_on            = [aws_s3_bucket.s3]
  bucket                = aws_s3_bucket.s3[0].id
  rule {
    object_ownership    = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "pb" {
  count                   = var.is_src_account && var.src_create_s3_bucket ? 1 : 0
  depends_on              = [aws_s3_bucket.s3]
  bucket                  = aws_s3_bucket.s3[0].id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "acl" {
  count                   = var.is_src_account && var.src_create_s3_bucket ? 1 : 0
  depends_on              = [aws_s3_bucket_ownership_controls.ownership]
  bucket                  = aws_s3_bucket.s3[0].id
  acl                     = "private"
}


# ---------------------------------------------------------------------------------------------------------------------
# IAM Role
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "datasync" {
  count                 = var.is_src_account && var.src_create_iam_role ? 1 : 0
  name                  = var.src_create_iam_role != null ? var.src_iam_role_name : null
  name_prefix           = var.src_iam_role_name != null ? null : "datasync"
  description           = "DataSync IAM Role"
  assume_role_policy    = data.aws_iam_policy_document.datasync_assume.json
  force_detach_policies = var.src_force_detach_policies
  permissions_boundary  = var.src_iam_role_permissions_boundary
  tags = var.tags
}

resource "aws_iam_role_policy" "datasync" {
  count                 = var.is_src_account && var.src_create_iam_role ? 1 : 0
  name_prefix           = "datasync"
  role                  = aws_iam_role.datasync[0].id
  policy                = data.aws_iam_policy_document.datasync.json
}

# ---------------------------------------------------------------------------------------------------------------------
# Datasync
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_datasync_location_s3" "this" {
  count                 = var.is_src_account && var.create_datasync_locations ? 1 : 0
  s3_bucket_arn         = var.dst_s3_bucket_arn
  subdirectory          = var.dst_s3_bucket_path

  s3_config {
    bucket_access_role_arn = var.src_create_iam_role ? aws_iam_role.datasync[0].arn : var.src_iam_role_arn
  }
}

##resource "aws_datasync_task" "this" {
##  destination_location_arn = aws_datasync_location_s3.destination.arn
##  name                     = "example"
##  source_location_arn      = aws_datasync_location_nfs.source.arn
##
##  options {
##    bytes_per_second = -1
##  }
##}
##
##resource "aws_datasync_task" "example2" {
##  destination_location_arn = aws_datasync_location_s3.destination.arn
##  name                     = "example"
##  source_location_arn      = aws_datasync_location_nfs.source.arn
##
##  schedule {
##    schedule_expression = "cron(0 12 ? * SUN,WED *)"
##  }
##}
##
##resource "aws_datasync_task" "example" {
##  destination_location_arn = aws_datasync_location_s3.destination.arn
##  name                     = "example"
##  source_location_arn      = aws_datasync_location_nfs.source.arn
##
##  excludes {
##    filter_type = "SIMPLE_PATTERN"
##    value       = "/folder1|/folder2"
##  }
##
##  includes {
##    filter_type = "SIMPLE_PATTERN"
##    value       = "/folder1|/folder2"
##  }
##}

# ---------------------------------------------------------------------------------------------------------------------
### Destination S3
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
