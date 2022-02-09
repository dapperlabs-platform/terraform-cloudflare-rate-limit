# Cloudflare Rate limit

data "cloudflare_zones" "zone" {
  filter {
    name = var.domain
  }
}

resource "cloudflare_rate_limit" "limit" {
  zone_id             = lookup(data.cloudflare_zones.zone.zones[0], "id")
  threshold           = var.threshold
  period              = var.period
  disabled            = var.disabled
  description         = var.description
  bypass_url_patterns = var.bypass_url_patterns

  match {
    request {
      url_pattern = var.request.url_pattern
      schemes     = var.request.schemes
      methods     = var.request.methods
    }

    response {
      statuses       = var.response.statuses
      origin_traffic = var.response.origin_traffic
      headers        = var.response.headers
    }
  }

  action {
    mode    = var.action.mode
    timeout = var.action.timeout

    dynamic "response" {
      for_each = var.action.response == null ? [] : [1]
      content {
        content_type = var.action.response.content_type
        body         = var.action.response.body
      }
    }
  }

  correlate {
    by = var.correlate_by
  }
}
