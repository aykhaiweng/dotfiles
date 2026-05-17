variable "account_id" {
  description = "Cloudflare account ID that owns the zone."
  type        = string
}

variable "app_name" {
  description = "Display name for the Access application."
  type        = string
}

variable "domain_uri" {
  description = "Hostname (with optional path) protected by Access. Wildcards allowed, including mid-label (e.g. svc-*.example.com)."
  type        = string
}

variable "allowed_emails" {
  description = "Emails permitted by the Access policy. One-time PIN is used when no IdP is configured."
  type        = list(string)
}

variable "session_duration" {
  description = "How long an Access session stays valid before re-auth."
  type        = string
  default     = "24h"
}

variable "bypass_paths" {
  description = <<-EOT
    Path patterns (relative to domain_uri) that skip Access entirely. Useful for
    webhook endpoints that can't do interactive auth. Each entry is appended to
    domain_uri to form a destination URI (e.g. "/webhooks/*").
    Leave empty to create no bypass app.
  EOT
  type        = list(string)
  default     = []
}
