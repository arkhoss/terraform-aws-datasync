######################## Details #######################
#  Split variables in Source (src) and Destination (dst)
#  * Source:
#  -- Required permissions for your source account
#  --- Assumable Role for DataSync
#  * Destination:
#  -- Required permissions for your destination account
#  --- S3 attached policy for DataSync
########################## END #########################

#----------------------------------------------------------------
#  Specify if it is the Source Account or the Destination Account 
#----------------------------------------------------------------
variable "is_src_account" {
  description = "Work over Source Accout"
  type        = bool
  default     = true
}

variable "src_account_id" {
  description = "Source Account ID"
  type        = string
  default     = null
}

variable "src_aws_region" {
  description = "Source AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "dst_aws_region" {
  description = "Destination AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "is_dst_account" {
  description = "Work over Destination Accout"
  type        = bool
  default     = true
}

#----------------------------------------------------------------
#  Source Role for DataSync
#----------------------------------------------------------------
variable "src_create_iam_role" {
  description = "Create IAM role for DataSync"
  type        = bool
  default     = true
}

variable "src_iam_role_name" {
  description = "IAM Role Name to be created"
  type        = string
  default     = null
}

variable "src_iam_role_permissions_boundary" {
  description = "IAM role Permission boundary - The policy for the Role"
  type        = string
  default     = null
}

variable "src_force_detach_policies" {
  description = "IAM role Force detach policies"
  type        = bool
  default     = false
}

variable "src_iam_role_arn" {
  description = <<-EOD
  (Required) The Amazon Resource Name (ARN) of the role that the Amazon DataSync can assume
  Mandatory if `src_create_iam_role=false`
  EOD
  type        = string
  default     = "arn:aws:iam::123456789012:role/source-datasync-role"
}

#----------------------------------------------------------------
#  Source Amazon S3 location
#----------------------------------------------------------------
variable "src_create_s3_bucket" {
  description = "Create new S3 bucket for DataSync location. "
  type        = string
  default     = true
}

variable "src_s3_bucket_name" {
  description = <<-EOD
  New bucket will be created with the given name for DataSync location when create_s3_bucket=true
  EOD
  type        = string
  default     = null
}

variable "src_s3_bucket_arn" {
  description = "(Required) The Amazon Resource Name (ARN) of your Amazon S3 storage bucket. For example, arn:aws:s3:::datasync-mybucketname"
  type        = string
  default     = null
}


variable "src_s3_bucket_path" {
  description = "Path in the source S3 bucket"
  type        = string
  default     = null
}

variable "src_s3_attached_policy" {
  description = "Amazon S3 attached policy"
  type        = string
  default     = null
}

#----------------------------------------------------------------
#  Amazon DataSync destination location in your source account.
#----------------------------------------------------------------

variable "task_create" {
  description = "Enable the creation of datasync task"
  type        = bool
  default     = false
}

#----------------------------------------------------------------
#  Amazon S3 in destination account
#----------------------------------------------------------------
#----------------------------------------------------------------
#  Source Role for DataSync
#----------------------------------------------------------------
variable "dst_create_iam_role" {
  description = "Create IAM role for DataSync"
  type        = bool
  default     = false
}

variable "dst_iam_role_name" {
  description = "IAM Role Name to be created"
  type        = string
  default     = null
}

variable "dst_iam_role_permissions_boundary" {
  description = "IAM role Permission boundary - The policy for the Role"
  type        = string
  default     = null
}

variable "dst_force_detach_policies" {
  description = "IAM role Force detach policies"
  type        = bool
  default     = false
}

variable "dst_iam_role_arn" {
  description = <<-EOD
  (Required) The Amazon Resource Name (ARN) of the role that the Amazon DataSync can assume
  Mandatory if `dst_create_iam_role=false`
  EOD
  type        = string
  default     = "arn:aws:iam::123456789012:role/destination-datasync-role"
}

variable "dst_create_s3_bucket" {
  description = "Create new S3 bucket for Destination. "
  type        = string
  default     = true
}

variable "dst_s3_bucket_name" {
  description = <<-EOD
  New bucket will be created with the given name for Destination when dst_create_s3_bucket=true
  EOD
  type        = string
  default     = null
}

variable "dst_s3_bucket_arn" {
  description =  <<-EOD
  (Required) The Amazon Resource Name (ARN) of your Amazon S3 storage bucket. For example, arn:aws:s3:::datasync-mybucketname"
  Mandatory if `dts_create_s3_bucket=false`
  EOD
  type        = string
  default     = null
}

variable "dst_s3_attach_custom_policy" {
  description = "Enable policy attach to the Destination S3 bucket"
  type        = bool
  default     = true
}

variable "dst_s3_custom_policy" {
  description = "Policy attached to the Destination S3 bucket"
  type        = string
  default     = null
}

variable "dst_s3_bucket_path" {
  description = "Path in the Destination S3 bucket"
  type        = string
  default     = null
}


### ACL disabled, S3_Attached_policy to the dst_s3_bucket. 


variable "tags" {
  description = "(Optional) A map of resource tags to associate with the resource"
  type        = map(string)
  default     = {}
}


#----------------------------------------------------------------
#  Amazon DataSync Task in your source account.
#----------------------------------------------------------------

variable "create_datasync_task" {
  description = "Enable the creation of datasync task"
  type        = bool
  default     = false
}

variable "task_name" {
  description = "Name for the task"
  type        = string
  default     = "example_task"
}
  
variable "task_src_location_s3" {
  description = "Location DST"
  type        = string
  default     = "example_task"
}

variable "task_dst_location_s3" {
  description = "Location DST"
  type        = string
  default     = "example_task"
}

variable "task_schedule" {
  description = "Schedule cronjob"
  type        = string
  default     = "cron(0 */8 * * ? *)"
}
