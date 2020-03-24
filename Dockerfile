FROM ubuntu:18.04

ENV XEM_VERSION=0.6.97
ENV XEM_CHECKSUM=a786ddd682f955bd7d22afd58d7cb0260105da12f9b5cfe1336f1ea11e67102b

RUN apt-get update && apt-get install -y wget openjdk-8-jre-headless && apt-get clean
RUN wget http://bob.nem.ninja/nis-${XEM_VERSION}.tgz \
    && echo "${XEM_CHECKSUM} nis-${XEM_VERSION}.tgz" | sha256sum -c \
    && tar -xzf nis-${XEM_VERSION}.tgz \
    && cp -r ./package/* /root/

RUN sed -i 's/nem.host = 127.0.0.1/nem.host = 0.0.0.0/g' /root/nis/config.properties
RUN sed -i 's/nis.additionalLocalIps =/nis.additionalLocalIps = *.*.*.*/g' /root/nis/config.properties
RUN sed -i 's/nis.transactionHashRetentionTime = 36/nis.transactionHashRetentionTime = 720/g' /root/nis/config.properties
RUN sed -i 's/nis.delayBlockLoading = true/nis.delayBlockLoading = false/g' /root/nis/config.properties

RUN sed -i 's/-Xms512M/-Xms3G/g' /root/nix.runNis.sh
RUN sed -i 's/-Xmx1G/-Xmx5G/g' /root/nix.runNis.sh

WORKDIR /root/

ENTRYPOINT ["/root/nix.runNis.sh"]
