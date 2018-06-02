
FROM alpine:latest

VOLUME [ "/caddy", "/znc" ]

ADD ./caddy-cert-to-znc.sh /script/copy.sh

CMD /script/copy.sh
