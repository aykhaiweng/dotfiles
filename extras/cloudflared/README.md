# cloudflared

## Cloudflare Tunnel SSH
Client-side config:
```
# ~/.ssh/config
Host ssh.example.com
  ProxyCommand /usr/local/bin/cloudflared access ssh --hostname %h
```

## Cloudflare Access (Terraform)

`terraform/` puts Cloudflare Access in front of a hostname (or wildcard
pattern) served through a Cloudflare Tunnel. DNS and the tunnel itself are
managed out-of-band; Terraform only owns the Access application + policy.

Auth model: One-time PIN — Cloudflare emails a code to the user, no IdP setup
required. Allowed emails are listed in `terraform.tfvars`.

```sh
cd extras/cloudflared/terraform
cp terraform.tfvars.example terraform.tfvars   # fill in account_id, domain, emails

export CLOUDFLARE_API_TOKEN=...                # needs: Access: Apps and Policies Edit

terraform init
terraform plan
terraform apply
```

To remove the gate: `terraform destroy`. The tunnel and DNS keep working;
requests will reach the origin without an Access challenge.
