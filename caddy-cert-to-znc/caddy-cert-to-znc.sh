#!/bin/sh

cat /caddy/acme/acme-v02.api.letsencrypt.org/sites/olmeca.snucse.org/olmeca.snucse.org.key \
    /caddy/acme/acme-v02.api.letsencrypt.org/sites/olmeca.snucse.org/olmeca.snucse.org.crt \
    > /znc/znc.pem
echo "Coppied!"
