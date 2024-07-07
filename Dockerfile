### ---------------------------------------: BASE
# Set SDK VERSION
ARG SDK_VERSION=7.1.1
FROM ghcr.io/adamjakab/connectiq-builder-sdk-v${SDK_VERSION}:latest AS base
RUN echo "Using Connect IQ SDK version: $SDK_VERSION"

### ---------------------------------------: BUILDER
FROM base AS builder
COPY entrypoint.sh /root/entrypoint.sh

### ---------------------------------------: RUNNER
FROM builder AS runner
ENTRYPOINT ["/root/entrypoint.sh"]
