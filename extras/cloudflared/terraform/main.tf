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

output "application_id" {
  value = cloudflare_zero_trust_access_application.dev_bench.id
}

output "application_aud" {
  description = "Audience tag — use this when validating Cf-Access-Jwt-Assertion at the origin."
  value       = cloudflare_zero_trust_access_application.dev_bench.aud
}
