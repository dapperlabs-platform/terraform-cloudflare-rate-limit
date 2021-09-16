variable "domain" {
  type        = string
  description = "Cloudflare Domain to be applied to"
}

variable "threshold" {
  type        = number
  description = "Combines with period, "
}

variable "period" {
  type        = number
  description = "time in SECONDS to count for the traffic (min: 1 second, max 86400 seconds)"
}

variable "disabled" {
  type        = bool
  default     = true
  description = "Wether this rate limit rule is Disabled"
}

variable "description" {
  type        = string
  description = "Description of this Rate limit"
  default     = "Managed By Terraform"
}

variable "bypass_url_patterns" {
  type        = list(string)
  default     = null
  description = "URLs Matching pattern would be excluded, and allowed to be passed (ignores rate limit)"
}

variable "correlate_by" {
  type        = string
  description = "if there is a NAT support"
  default     = null
}

variable "request" {

  type = object({
    url_pattern = string
    schemes     = list(string)
    methods     = list(string)
  })
}

variable "response" {
  type = object({
    statuses       = list(number)
    origin_traffic = bool
    headers = list(object({
      name  = string
      op    = string
      value = string
    }))
  })

  default = {
    statuses       = null
    origin_traffic = null
    headers        = null
  }
}

variable "action" {
  type = object({
    mode    = string
    timeout = number
    response = object({
      content_type = string
      body         = string
    })
  })
}
