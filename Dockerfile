FROM nforceroh/docker-alpine-base

MAINTAINER Sylvain Martin (sylvain@nforcer.com)

ENV UMASK=000
ENV PUID=3001
ENV PGID=3000
ENV TZ=America/New_York

RUN true && apk update && apk upgrade && \
        apk add --update dovecot dovecot-mysql && \
        (rm "/tmp/"* 2>/dev/null || true) && (rm -rf /var/cache/apk/* 2>/dev/null || true)

RUN mkdir -p /data/vmail
COPY rootfs/ /

RUN sed -i -e 's,#log_path = syslog,log_path = /dev/stderr,' \
           -e 's,#info_log_path =,info_log_path = /dev/stdout,' \
           -e 's,#debug_log_path =,debug_log_path = /dev/stdout,' \
        /etc/dovecot/conf.d/10-logging.conf 

RUN addgroup -S -g ${PGID} vmail
RUN adduser -S -D -H -u ${PUID} -G vmail -g "Dovecot Vmail" vmail
RUN chown -R vmail:vmail /data/vmail
RUN mkdir -p /srv && ln -s /data/vmail /srv/vmail

#Exposing tcp ports
EXPOSE 143 993

#Adding volumes
VOLUME ["/data"]

# Running final script
#ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
