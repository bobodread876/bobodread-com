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

## Revamp staging (review before production)

Branch: `bobodread-sharpen`. Cloudflare Pages project: `bobodread-review`.
Review URL: https://bobodread-review.pages.dev/
The review project uses `bobodread-sharpen` as its default deployment branch.
Cloudflare calls this its production environment; it is staging for this site,
with no connection to the actual bobodread.com production host.
This is a separate preview host; it does not serve bobodread.com and has no
custom domain attached. No Git-triggered production deployment is configured.

Prepare the public-only upload directory, then publish to the preview branch:

```sh
sh prepare-preview.sh
wrangler pages deploy .preview --project-name bobodread-review --branch bobodread-sharpen
```

The staging package adds `noindex` headers and a crawl-disallowing robots.txt.
These are preview-only. Production HTML keeps its bobodread.com canonicals.

### Production promotion — only after review

Production remains on Caddy. Deploy the complete asset set together:
`index.html`, `media.html`, `style.css`, `photo.png`, `pgp.asc`, and
`social-card.png`, and `404.html`. Do not upload the preview directory or its staging headers.
Take a backup of the existing site files and Caddy configuration first.

The new `/media` links require the following additions inside the existing
bobodread.com Caddy site block (preserve all existing rules and handlers):

```caddyfile
redir /media.html /media permanent
redir /index.html / permanent
rewrite /media /media.html
```

Validate the Caddy configuration before reloading. After promotion, verify
`/`, `/media`, both legacy redirects, CSS, portrait, social card, and PGP file.
Keep the previous asset set and config available for rollback. Do not copy
Cloudflare `_redirects` to Caddy; Caddy does not interpret that file.

### Editorial review still needed

- Patoo copy describes the existing public ideas and skills pages. Confirm
  current tools and actual daily workflows before making stronger claims.
- Existing email and booking addresses are retained pending a contact decision.
- Melissa stays in the media archive; no new uptime or agent claims were added.
- Release/repository totals were removed in favor of direct code/release links.
