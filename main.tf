# Cloudflare Rate limit
data "cloudflare_zones" "zones" {
  count = length(var.domains)

  filter {
    name        = var.domains[count.index]
    lookup_type = "exact"
    paused      = false
  }
}

#resource "cloudflare_rate_limit" "limit" {
#  zone_id             = lookup(data.cloudflare_zones.zone.zones[0], "id")
#  threshold           = var.threshold
#  period              = var.period
#  disabled            = var.disabled
#  description         = var.description
#  bypass_url_patterns = var.bypass_url_patterns
#
#  match {
#    request {
#      url_pattern = var.request.url_pattern
#      schemes     = var.request.schemes
#      methods     = var.request.methods
#    }
#
#    dynamic "response" {
#      for_each = var.response == null ? [] : [1]
#      content {
#        statuses       = var.response.statuses
#        origin_traffic = var.response.origin_traffic
#        headers        = var.response.headers
#      }
#    }
#  }
#
#  action {
#    mode    = var.action.mode
#    timeout = var.action.timeout
#
#    dynamic "response" {
#      for_each = try(var.action.response, null) == null ? [] : [1]
#      content {
#        content_type = var.action.response.content_type
#        body         = var.action.response.body
#      }
#    }
#  }
#
#  dynamic "correlate" {
#    for_each = var.correlate_by == null ? [] : [1]
#    content {
#      by = var.correlate_by
#    }
#  }
#}
#
#
resource "cloudflare_ruleset" "zone_level_ratelimit" {
  count = length(var.domains)

  zone_id = lookup(data.cloudflare_zones.zones[count.index].zones[0], "id")
  name    = "Rate limiting for my zone"
  kind    = "zone"
  phase   = "http_ratelimit"

  dynamic "rules" {
    for_each = var.rate_limit_rules
    content {
      description = rules.value.description
      expression  = rules.value.expression
      action      = rules.value.action
      enabled     = rules.value.enabled
      ratelimit {
        characteristics            = rules.value.characteristics
        counting_expression        = rules.value.counting_expression
        requests_per_period        = rules.value.requests_per_period
        period                     = rules.value.period
        requests_to_origin         = rules.value.requests_to_origin
        score_per_period           = rules.value.score_per_period
        score_response_header_name = rules.value.score_response_header_name
        mitigation_timeout         = rules.value.mitigation_timeout
      }
    }
  }
}
