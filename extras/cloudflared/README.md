# Cloudflare Tunnel SSH
## Client-side configuration
```~/.ssh/config
Host ssh.example.com
  ProxyCommand /usr/local/bin/cloudflared access ssh --hostname %h
```
