resource "cloudflare_zero_trust_access_application" "dev_bench" {
  account_id       = var.account_id
  name             = var.app_name
  type             = "self_hosted"
  session_duration = var.session_duration

  destinations = [{
    type = "public"
    uri  = var.domain_uri
  }]

  # Cloudflared sits between Access and the origin; skip the interstitial so
  # JWT-aware clients (browser auth handled by Access at the edge) work cleanly.
  skip_interstitial = true

  policies = [{
    name       = "Allow listed emails"
    decision   = "allow"
    precedence = 1
    include = [
      for email in var.allowed_emails : {
        email = { email = email }
      }
    ]
  }]
}

# Cloudflare evaluates Access apps by path specificity, so this app wins over
# the parent for the listed paths and lets requests through without auth.
resource "cloudflare_zero_trust_access_application" "bypass" {
  count = length(var.bypass_paths) > 0 ? 1 : 0

  account_id        = var.account_id
  name              = "${var.app_name} (bypass)"
  type              = "self_hosted"
  session_duration  = var.session_duration
  skip_interstitial = true

  destinations = [
    for path in var.bypass_paths : {
      type = "public"
      uri  = "${var.domain_uri}${path}"
    }
  ]

  policies = [{
    name       = "Bypass auth"
    decision   = "bypass"
    precedence = 1
    include    = [{ everyone = {} }]
  }]
}

output "application_id" {
  value = cloudflare_zero_trust_access_application.dev_bench.id
}

output "application_aud" {
  description = "Audience tag — use this when validating Cf-Access-Jwt-Assertion at the origin."
  value       = cloudflare_zero_trust_access_application.dev_bench.aud
}
