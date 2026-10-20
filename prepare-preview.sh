#!/bin/sh
# Package only public assets; staging headers never enter the production files.
set -eu
cd "$(dirname "$0")"
mkdir -p .preview
cp index.html media.html 404.html style.css photo.png social-card.png .preview/
printf '/media.html /media 301\n/index.html / 301\n' > .preview/_redirects
printf '/*\n  X-Robots-Tag: noindex, nofollow\n  X-Content-Type-Options: nosniff\n' > .preview/_headers
printf 'User-agent: *\nDisallow: /\n' > .preview/robots.txt
