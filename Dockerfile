FROM ghcr.io/adamjakab/connectiq-builder:latest

COPY entrypoint.sh /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]
