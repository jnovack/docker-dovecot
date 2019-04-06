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

# DHE Groups from https://wiki.mozilla.org/Security/Server_Side_TLS#Pre-defined_DHE_groups
ADD ffdhe2048.pem /etc/ssl/ffdhe2048.pem
ADD ffdhe4096.pem /etc/ssl/ffdhe4096.pem

RUN apk update && \
    apk add tzdata pwgen dovecot dovecot-pop3d && \
    mkdir -p /var/mail && \
    chown mail.mail /var/mail && \
    addgroup -g 65530 catchall && \
    adduser -u 65530 -G catchall -D catchall

COPY entrypoint.sh /entrypoint.sh
COPY local.conf /etc/dovecot/local.conf

ENTRYPOINT [ "/entrypoint.sh" ]