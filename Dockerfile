FROM ghcr.io/adamjakab/connectiq-builder:latest

# ARG CONNECTIQ_DEVELOPER_KEY=${CONNECTIQ_DEVELOPER_KEY}
# ENV CONNECTIQ_DEVELOPER_KEY=${CONNECTIQ_DEVELOPER_KEY}


COPY entrypoint.sh /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]
