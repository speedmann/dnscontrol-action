FROM alpine:3.20.3@sha256:beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d

LABEL repository="https://github.com/speedmann/dnscontrol-action"
LABEL maintainer="speedmann <speedmann@speedmann.de>"

LABEL "com.github.actions.name"="DNSControl"
LABEL "com.github.actions.description"="Deploy your DNS configuration to multiple providers."
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="yellow"

ENV DNSCONTROL_VERSION="4.14.0"
ENV DNSCONTROL_CHECKSUM="5910b04d7998aa2af6f16852e042fbe9579535d440b162068d90aa6de15d462c"

RUN apk -U --no-cache upgrade && \
    apk add --no-cache bash ca-certificates curl libc6-compat
RUN curl -sL "https://github.com/StackExchange/dnscontrol/releases/download/v${DNSCONTROL_VERSION}/dnscontrol_${DNSCONTROL_VERSION}_linux_amd64.tar.gz" \
  -o dnscontrol.tar.gz && \
  echo "$DNSCONTROL_CHECKSUM  dnscontrol.tar.gz" | sha256sum -c - && \
  tar xfvz dnscontrol.tar.gz && \
  chmod +x dnscontrol && \
  mv dnscontrol /usr/local/bin/dnscontrol

RUN ["dnscontrol", "version"]

COPY README.md entrypoint.sh bin/filter-preview-output.sh /
ENTRYPOINT ["/entrypoint.sh"]
