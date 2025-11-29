# Build stage
FROM golang:1.25-alpine3.22 AS builder

RUN apk add --no-cache --update alpine-sdk bash

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o bin/dex-k8s-authenticator *.go

# Runtime stage
FROM alpine:3.22

# Security: Add labels
LABEL maintainer="mintel" \
      org.opencontainers.image.title="dex-k8s-authenticator" \
      org.opencontainers.image.description="Kubernetes authentication helper for Dex" \
      org.opencontainers.image.vendor="Mintel"

# Dex connectors, such as GitHub and Google logins require root certificates.
# Proper installations should manage those certificates, but it's a bad user
# experience when this doesn't work out of the box.
#
# OpenSSL is required so wget can query HTTPS endpoints for health checking.
RUN apk add --no-cache ca-certificates openssl curl tini && \
    rm -rf /var/cache/apk/*

# Create non-root user for security
RUN addgroup -g 1000 dex && \
    adduser -u 1000 -G dex -s /bin/sh -D dex

RUN mkdir -p /app/bin /certs && \
    chown -R dex:dex /app /certs

COPY --from=builder --chown=dex:dex /app/bin/dex-k8s-authenticator /app/bin/
COPY --from=builder --chown=dex:dex /app/html /app/html
COPY --from=builder --chown=dex:dex /app/templates /app/templates

WORKDIR /app

COPY --chown=dex:dex entrypoint.sh /
RUN chmod a+x /entrypoint.sh

# Switch to non-root user
USER dex

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5555/ || exit 1

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]

CMD ["--help"]
