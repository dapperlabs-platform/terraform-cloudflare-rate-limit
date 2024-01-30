variable "domains" {
  type        = string
  description = "The DNS zone ID to apply rate limiting to"
}

#variable "threshold" {
#  type        = number
#  description = "The threshold that triggers the rate limit mitigations (min: 2, max: 1,000,000)"
#}
#
#variable "period" {
#  type        = number
#  description = "Time in SECONDS to count requests (min: 10 seconds, max 86,400 seconds)"
#  default     = 10
#  validation {
#    condition     = var.period >= 10
#    error_message = "The period should be at least 10."
#  }
#}
#
#variable "disabled" {
#  type        = bool
#  default     = true
#  description = "Whether this ratelimit is currently disabled"
#}
#
#variable "description" {
#  type        = string
#  description = "Description of this Rate limit"
#  default     = "Managed By Terraform"
#}
#
#variable "bypass_url_patterns" {
#  type        = list(string)
#  default     = null
#  description = "URLs matching the patterns specified here will be excluded from rate limiting"
#}
#
#variable "correlate_by" {
#  type        = string
#  description = "Determines how rate limiting is applied. By default if not specified, rate limiting applies to the clients IP address"
#  default     = null
#}
#
#variable "request" {
#  description = "Matches HTTP requests (from the client to Cloudflare)"
#  type = object({
#    url_pattern = string
#    schemes     = list(string)
#    methods     = list(string)
#  })
#}
#
#variable "response" {
#  description = "Matches HTTP responses before they are returned to the client from Cloudflare. If this is defined, then the entire counting of traffic occurs at this stage"
#  type = object({
#    statuses       = list(number)
#    origin_traffic = bool
#    headers = list(object({
#      name  = string
#      op    = string
#      value = string
#    }))
#  })
#  default = null
#}
#
#variable "action" {
#  description = <<EOT
#    The action to be performed when the threshold of matched traffic within the period defined is exceeded."
#    {
#      mode    = string
#      timeout = number
#      response = object({
#        content_type = string
#        body         = string
#      })
#    }
#  EOT
#  type        = any
#  default     = null
#}

variable "rate_limit_rules" {
  type = map(object({
    rules = map(object({
      action      = string,
      expression  = string,
      description = string,
      enabled     = bool,
    }))
    rate_limit = map(object({
      characteristics     = string,
      period              = number,
      requests_per_period = number,
      mitigation_timeout  = number,
    }))
  }))
}
