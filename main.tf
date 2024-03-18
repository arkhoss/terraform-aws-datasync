###

resource "aws_datasync_task" "this" {
  destination_location_arn = aws_datasync_location_s3.destination.arn
  name                     = "example"
  source_location_arn      = aws_datasync_location_nfs.source.arn

  options {
    bytes_per_second = -1
  }
}

resource "aws_datasync_task" "example" {
  destination_location_arn = aws_datasync_location_s3.destination.arn
  name                     = "example"
  source_location_arn      = aws_datasync_location_nfs.source.arn

  schedule {
    schedule_expression = "cron(0 12 ? * SUN,WED *)"
  }
}

resource "aws_datasync_task" "example" {
  destination_location_arn = aws_datasync_location_s3.destination.arn
  name                     = "example"
  source_location_arn      = aws_datasync_location_nfs.source.arn

  excludes {
    filter_type = "SIMPLE_PATTERN"
    value       = "/folder1|/folder2"
  }

  includes {
    filter_type = "SIMPLE_PATTERN"
    value       = "/folder1|/folder2"
  }
}



resource "aws_datasync_location_s3" "example" {
  s3_bucket_arn = aws_s3_bucket.example.arn
  subdirectory  = "/example/prefix"

  s3_config {
    bucket_access_role_arn = aws_iam_role.example.arn
  }
}


