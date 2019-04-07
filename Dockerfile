FROM nforceroh/docker-alpine-base
LABEL maintainer="Sylvain Martin (sylvain@nforcer.com)"

ENV UMASK=000
ENV PUID=3001
ENV PGID=3000
ENV TZ=America/New_York

RUN true && \
    echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
	apk update && apk upgrade && \
	apk add \
		dovecot \
		dovecot-mysql \
		dovecot-lmtpd \
		dovecot-pigeonhole-plugin \
		mariadb-client \
		rspamd-client \
	&& \
### Create Vmail User
	addgroup -S -g 5000 vmail && \
	adduser -S -D -H -u 5000 -G vmail -g "Dovecot Vmail" vmail \
	&& \
### Setup Container for Dovecot
	rm -rf /etc/dovecot/* && \
	mkdir -p /var/lib/dovecot && \
	mkdir -p /var/log/dovecot \
	&& \
### Cleanup
	rm -rf /var/cache/apk/* /usr/src/*

### Add Files
ADD install /
#	COPY rootfs/ /

#Exposing tcp ports
EXPOSE 143 993

#Adding volumes
VOLUME ["/var/mail"]