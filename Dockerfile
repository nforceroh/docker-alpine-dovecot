FROM nforceroh/d_alpine-s6:edge
LABEL maintainer="Sylvain Martin (sylvain@nforcer.com)"

ENV UMASK=000 \
	PUID=3001 \
	PGID=3000 \
	TZ=America/New_York \
	DB_HOST=db \
	DB_PORT=3306 \
	DB_NAME=mail \
	DB_USER=user \
	DB_PASS=password \
	VMAIL_UID=5000 \
	VMAIL_GID=12


RUN echo "Installing Dovecot" \
	&& apk update \
	&& apk upgrade \
	&& apk add \
		bash \
		dovecot \
		dovecot-mysql \
		dovecot-lmtpd \
		dovecot-pigeonhole-plugin \
		mariadb-client \
		rspamd-client \
### Create Vmail User
	&& adduser -S -D -H -u ${VMAIL_UID} -G mail -g "Dovecot Vmail" vmail \
### Setup Container for Dovecot
#	mkdir -p /var/lib/dovecot && \
	&& mkdir -p /var/log/dovecot \
### Cleanup
	&& rm -rf /var/cache/apk/* /usr/src/*

### Add Files
ADD install /

#Exposing tcp ports
EXPOSE 24 143 993 3333

#Adding volumes
VOLUME ["/data"]