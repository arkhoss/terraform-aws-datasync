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
#  IAM role for DataSync in source account
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

variable "src_role_arn" {
  description = <<-EOD
  (Required) The Amazon Resource Name (ARN) of the role that the Amazon DataSync can assume
  Mandatory if `src_create_iam_role=false`
  EOD
  type        = string
  default     = null
}

#----------------------------------------------------------------
#  Amazon S3 location in source account
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

#----------------------------------------------------------------
#  Amazon DataSync destination location in your source account.
#----------------------------------------------------------------



#----------------------------------------------------------------
#  Amazon S3 in destination account
#----------------------------------------------------------------
variable "dts_create_s3_bucket" {
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

variable "dst_s3_attached_policy" {
  description = "Policy attached to the Destination S3 bucket"
  type        = string
  default     = null
}

### ACL disabled, S3_Attached_policy to the dst_s3_bucket. 


