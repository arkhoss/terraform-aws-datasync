#####################
#####################

variable "description" {
  description = "(Optional) Description of the REST API. If importing an OpenAPI specification via the `body` argument, this corresponds to the `info.description` field. If the argument value is provided and is different than the OpenAPI value, the argument value will override the OpenAPI value."
  type        = string
  default     = null
}

