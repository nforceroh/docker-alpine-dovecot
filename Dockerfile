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
EXPOSE 110 #pop3
EXPOSE 143 #imap
EXPOSE 993 #imaps
EXPOSE 995 #pop3s

#Adding volumes
VOLUME ["/data"]

# Running final script
#ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
