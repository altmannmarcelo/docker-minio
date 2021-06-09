# Pull base image.
FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update ;\
    apt-get install -y sudo dsniff vim wget net-tools iproute2 curl jq

COPY entrypoint.sh /bin/entrypoint.sh

RUN wget https://dl.min.io/server/minio/release/linux-amd64/minio -O /usr/bin/minio && \
    chmod +x /usr/bin/minio /bin/entrypoint.sh

RUN mkdir /mnt/data

EXPOSE 9000

CMD ["/bin/entrypoint.sh"]