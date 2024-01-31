# Cloudflare Rate limit
data "cloudflare_zones" "zones" {
  count = length(var.domains)

  filter {
    name        = var.domains[count.index]
    lookup_type = "exact"
    paused      = false
  }
}

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
