FROM almalinux:8
# args
ARG FILE_DIRECTORY
# timezone
RUN \cp -pf /usr/share/zoneinfo/Japan /etc/localtime
# dnf install
RUN dnf -y update && dnf -y install \
    epel-release \
    sudo \
    less \
    procps \
    # network ss (instaed of netstat)
    iproute \
    # SSL
    openssl \
    mod_ssl
# SSL
RUN mkdir -p /etc/pki/CA/newcerts
RUN echo 00 > /etc/pki/CA/serial
RUN touch /etc/pki/CA/index.txt
RUN mkdir -p /var/certtemp
# volume directory
RUN mkdir -p /etc/ssl/private
RUN mkdir /template
RUN mkdir /workspace