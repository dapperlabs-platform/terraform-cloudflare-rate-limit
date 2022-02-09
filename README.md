# Cloudflare Rate Limit Module

https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/rate_limit

## What does this do?

This module allows you to create a CF Ratelimit rule to limit the traffic you receive zone-wide, or matching more specific types of requests/responses

## How to use this module?

```hcl
module "module_name" {

 source = "github.com/dapperlabs-platform/terraform-cloudflare-rate-limit?ref=tag"

 threshold           = 500
 period              = 60
 disabled            = false
 description         = "this is just a quick test"

 request = {
   url_pattern = var.url_pattern
   schemes     = [
     "HTTP",
     "HTTPS"
   ]
   methods = ["_ALL_"]
 }

 action = {
   mode    = "simulate"
   timeout = 60
   #response = null
 }

 domain = var.domain
}

```

## Required Providers

| NAME                  | VERSION CONSTRAINTS |
| --------------------- | ------------------- |
| cloudflare/cloudflare | ~> 2.19.0           |

| name                | description                                                                             |             type              | required | default |
| ------------------- | --------------------------------------------------------------------------------------- | :---------------------------: | :------: | :-----: |
| domain              | (Required) Cloudflare Domain to be applied to                                           | <code title="">string</code>  |    ✓     |         |
| threshold           | Combines with period                                                                    | <code title="">number</code>  |    ✓     |         |
| period              | time in SECONDS to count for the traffic (min: 1 second, max 86400 seconds)             | <code title="">number</code>  |    ✓     |         |
| disabled            | Turn ON/OFF Rate Limiting Rule                                                          | <code title="">boolean</code> |          |         |
| paused              | (Optional) Whether this filter based firewall rule is currently paused. Boolean value.  | <code title="">string</code>  |          |         |
| description         | URLs Matching pattern would be excluded, and allowed to be passed (ignores rate limit). | <code title="">string</code>  |    ✓     |         |
| bypass_url_patterns | (Optional) List of products to bypass for a request when the bypass action is used.     | <code title="">string</code>  |          |         |
| correlate_by        | Use if there is NAT Support                                                             | <code title="">string</code>  |          |         |
| request             | Request                                                                                 | <code title="">object</code>  |          |         |
| response            | Response                                                                                | <code title="">object</code>  |          |         |
| action              | Action                                                                                  | <code title="">object</code>  |          |         |
