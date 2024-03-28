data "aws_partition" "current" {}

data "aws_region" "current" {}

# ---------------------------------------------------------------------------------------------------------------------
# DataSync Role
# ---------------------------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "datasync_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
        type        = "Service"
        identifiers = ["datasync.amazonaws.com"]
    }

    principals {
        type        = "Service"
        identifiers = ["s3.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "datasync" {

  statement {
    effect = "Allow"
    actions = [ 
        "s3:GetBucketLocation",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads"
    ]
    resources = [
        "arn:aws:s3:::${var.src_s3_bucket_name}",
        "arn:aws:s3:::${var.dst_s3_bucket_name}"
        ]
    }

  statement {
    effect = "Allow"
    actions = [
        "s3:AbortMultipartUpload",
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:ListMultipartUploadParts",
        "s3:PutObjectTagging",
        "s3:GetObjectTagging",
        "s3:PutObject"
    ]
    resources = [
        "arn:aws:s3:::${var.src_s3_bucket_name}",
        "arn:aws:s3:::${var.dst_s3_bucket_name}/*"
        ]
    }

}


data "aws_iam_policy_document" "dst_s3_attached_policy" {
  statement {
    principals {
        type        = "AWS"
        identifiers = [var.src_iam_role_arn]
    }

    actions = [
        "s3:ListBucket",
        "s3:ListBucketVersions",
        "s3:GetBucketAcl",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:DeleteObject",
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:ListBucketMultipartUploads",
        "s3:ListMultipartUploadParts",
        "s3:GetObjectTagging",
        "s3:PutObjectTagging"
    ]

    resources = [
        "arn:aws:s3:::${var.dst_s3_bucket_name}",
        "arn:aws:s3:::${var.dst_s3_bucket_name}/*"
    ]
  }
}