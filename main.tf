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
  zone_id     = lookup(data.cloudflare_zones.zone.zones[0], "id")
  name        = "Rate limiting for my zone"
  description = ""
  kind        = "zone"
  phase       = "http_ratelimit"

  dynamic "rules" {
    for_each = var.rate_limit_rules.rules
    content {
      action      = rules.value.action
      expression  = rules.value.expression
      description = rules.value.description
      enabled     = rules.value.enabled
      dynamic "ratelimit" {
        for_each = var.rate_limit_rules.rate_limit
        content {
          characteristics     = ratelimit.value.characteristics
          period              = ratelimit.value.period
          requests_per_period = ratelimit.value.requests_per_period
          mitigation_timeout  = ratelimit.value.mitigation_timeout
        }
      }
    }
  }
}
