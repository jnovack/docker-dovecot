FROM alpine:latest

ENV VERSION="0" RELEASE=1 NAME=dovecot ARCH=x86_64
LABEL MAINTAINER "Justin J. Novack" <jnovack@gmail.com>
LABEL summary="Dovecot container for IMAP server." \
      name="$FGC/$NAME" \
      version="$VERSION" \
      release="$RELEASE.$DISTTAG" \
      architecture="$ARCH" \
      com.redhat.component="$NAME" \
      usage="docker run -it --privileged dovecot" \
      help="Runs dovecot. No dependencies. See Help File below for more details." \
      description="Dovecot container for IMAP server." \
      io.k8s.description="Dovecot container for IMAP server." \
      io.k8s.diplay-name="3.1" \
      io.openshift.tags="dovecot"

# Expose IMAPS
EXPOSE 993
# Expose POPS
EXPOSE 995

RUN apk update && \
    apk add pwgen dovecot && \
    mkdir -p /var/mail && \
    chown mail.mail /var/mail && \
    addgroup -g 65530 catchall && \
    adduser -u 65530 -G catchall -D catchall && \
    echo "ssl_protocols = TLSv1" >> /etc/dovecot/conf.d/10-ssl.conf && \
    echo "mail_location = mbox:~/mail:INBOX=/var/mail/%u" >> /etc/dovecot/conf.d/10-mail.conf && \
    echo "mail_privileged_group = mail" >> /etc/dovecot/conf.d/10-mail.conf && \
    echo "log_path = /dev/stderr" >> /etc/dovecot/conf.d/10-logging.conf

COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]