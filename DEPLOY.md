# Deploying bobodread.com

The site is served by Caddy (file_server) on the islandbitcoin-server droplet,
not a hosting platform. There is no CI.

- Content lives at `/opt/stack/bobodread.com/` on 206.189.139.60 (mounted into
  the caddy container at /srv/bobodread.com).
- To deploy: `scp index.html root@206.189.139.60:/opt/stack/bobodread.com/`
- Redirects are Caddy `redir` rules in `/opt/stack/caddy/Caddyfile` (the
  bobodread.com site block), then `docker exec caddy caddy reload --config
  /etc/caddy/Caddyfile`. The offer pages (/audit, /relationship-os) 301 to
  jabariennis.com there.
