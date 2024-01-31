variable "domains" {
  type        = list(string)
  description = "Cloudflare Domain to be applied to"
  default     = []
}

variable "rate_limit_rules" {
  type = map(object({
    description = string,
    expression  = string,
    action      = string,
    enabled     = bool,

    characteristics            = optiona(list(string), (["cf.colo.id", "ip.src"])),
    counting_expression        = optional(string),
    requests_per_period        = number,
    period                     = number,
    requests_to_origin         = optional(bool, true),
    score_per_period           = optional(number),
    score_response_header_name = optional(string),
    mitigation_timeout         = number,
  }))
}
