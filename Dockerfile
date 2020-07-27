FROM nforceroh/d_alpine-s6:dev
LABEL maintainer="Sylvain Martin (sylvain@nforcer.com)"

ENV UMASK=000 \
	PUID=3001 \
	PGID=3000 \
	TZ=America/New_York \
	DB_HOST=maridb \
	DB_PORT=3306 \
	DB_NAME=mail \
	DB_USER=user \
	DB_PASS=password \
	VMAIL_UID=5000 \
	VMAIL_GID=12 \
	CERTBOT_ENABLE=false \
    CERTBOT_CF_TOKEN='' \
    CERTBOT_EMAIL='' \
    FQDN=mail.example.com 

RUN echo "Installing Dovecot" \
	&& apk update \
	&& apk upgrade \
	&& apk add --no-cache dovecot dovecot-mysql dovecot-lmtpd dovecot-pigeonhole-plugin mariadb-client \
		rspamd-client ca-certificates \
	&& update-ca-certificates \
	&& ln -s /data/letsencrypt /etc/letsencrypt \
	&& apk add --no-cache certbot \
### Create Vmail User
	&& adduser -S -D -H -u ${VMAIL_UID} -G mail -g "Dovecot vMail" vmail \
### Setup Container for Dovecot
#	mkdir -p /var/lib/dovecot && \
	&& mkdir -p /var/log/dovecot \
### cloudflare deps
	&& apk add --no-cache --virtual .build-deps gcc musl-dev python3-dev libffi-dev openssl-dev \
    && pip install certbot-dns-cloudflare \
### Cleanup
    && apk del .build-deps gcc musl-dev \
	&& rm -rf /var/cache/apk/* /usr/src/*

### Add Files
ADD install /

# dovecot
#   24 ltmp, 110 pop3, 143 imap, 993 imaps, 4190 sieve, 12345 sasl
EXPOSE 24 110 143 993 4190 12345

#Adding volumes
VOLUME ["/data"]
ENTRYPOINT [ "/init" ]
