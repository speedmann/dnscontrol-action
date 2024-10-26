FROM alpine:3.20.3@sha256:beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d

LABEL repository="https://github.com/speedmann/dnscontrol-action"
LABEL maintainer="speedmann <speedmann@speedmann.de>"

LABEL "com.github.actions.name"="DNSControl"
LABEL "com.github.actions.description"="Deploy your DNS configuration to multiple providers."
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="yellow"

ENV DNSCONTROL_VERSION="4.5.0"
ENV DNSCONTROL_CHECKSUM="de1bf2c40e50fa21d72acdb7c53a9cd5b3883bb0ffcf18368a5e26a93f78290b"

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
