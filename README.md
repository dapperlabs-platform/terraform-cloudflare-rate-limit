# Cloudflare Rate Limit Module

https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/ruleset

## What does this do?

This module allows you to create a CF Ratelimit rule to limit the traffic you receive zone-wide, or matching more specific types of requests/responses

## How to use this module?

With the introduction of Rulesets, you no longer create a resource per rule. Instead you create ONE ruleset per zone with rules defined within the resource. This will mean any rules that are deleted won't show in terraform as being delted but as the ruleset being updated.

Priority is also set by the order in which the rules are displayed and not set by a condition.

```hcl
module "module_name" {
  source = "github.com/dapperlabs-platform/terraform-cloudflare-rate-limit?ref=mgardner-ratelimit-v2"
  domains = [
    data.cloudflare_zone.internal_zone.name
  ]
  # The order of the rules below will set the order in the Cloudflare dashboard.
  rate_limit_rules = {
    "rate_limit_name" = {
      action              = "block",
      expression          = <<EOT
        http.request.full_uri eq "api.domain.com"
        EOT
      description         = "quick test rate limit",
      enabled             = false,
      period              = 60, # seconds
      requests_per_period = 100,
      mitigation_timeout  = 600, # seconds
    },
  }
}

```

## Required Providers

| NAME                  | VERSION CONSTRAINTS |
| --------------------- | ------------------- |
| cloudflare/cloudflare | ~> 4.1           |

| name                | description                                                                             |             type              | required | default |
| ------------------- | --------------------------------------------------------------------------------------- | :---------------------------: | :------: | :-----: |
| domain              | (Required) Cloudflare Domain to be applied to                                           | <code title="">list</code>    |    ✓     |         |
| description         | (Required) Name and description of the rule                                             | <code title="">string</code>  |    ✓     |         |
| expression          | (Required) Firewall Rules expression language to target the rule                        | <code title="">string</code>  |    ✓     |         |
| action              | (Required) Block, skip etc                                                              | <code title="">string</code>  |    ✓     |         |
| enabled             | (Required)Turn ON/OFF Rate Limiting Rule                                                | <code title="">bool</code>    |    ✓     |         |
| characteristics     | (Required)How Cloudflare tracks the request rate for this rule.                         | <code title="">list</code>    |    ✓     |[cf.colo.id", "ip.src"]|
| counting_expression | (Optional) Criteria for counting HTTP requests to trigger the Rate Limiting action      | <code title="">string</code>  |          |         |
| requests_per_period | (Required) Number of requests over the period of time that will trigger the rule        | <code title="">number</code>  |    ✓     |         |
| period              | (Required) Period of time to consider (in seconds) when evaluating the request rate     | <code title="">string</code>  |    ✓     |         |
| requests_to_origin  | (Optional) Whether to include requests to origin within the Rate Limiting count         | <code title="">bool</code>    |          |   true  |
| score_per_period    | (Optional) Maximum aggregate score over the period of time that will trigger the rule   | <code title="">number</code>  |          |         |
| score_response_header_name | (Optional) Name of HTTP header in the response, set by the origin server, with the score for the current request | <code title="">string</code>  |          |         |
| mitigation_timeout  | (Required) Once the request rate is reached, blocks requests for the period of time     | <code title="">number</code>  |    ✓     |         |
