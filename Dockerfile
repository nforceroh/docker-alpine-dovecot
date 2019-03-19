FROM nforceroh/docker-alpine-base

MAINTAINER Sylvain Martin (sylvain@nforcer.com)

ENV UMASK=000
ENV PUID=3001
ENV PGID=3000
ENV TZ=America/New_York

RUN true && apk update && apk upgrade && \
        apk add --update dovecot && \
        (rm "/tmp/"* 2>/dev/null || true) && (rm -rf /var/cache/apk/* 2>/dev/null || true)

#COPY postfix.sh /postfix.sh
#COPY assp.sh /assp.sh
#RUN chmod +x /postfix.sh
#RUN chmod +x /assp.sh

#Exposing tcp ports
#pop3
EXPOSE 110
#imap
EXPOSE 143
#imaps
EXPOSE 993
#pop3s
EXPOSE 995

#Adding volumes
VOLUME ["/data"]

# Running final script
#ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
