FROM ubuntu:latest


ENV RUST_BACKTRACE=full

ENV LANGUAGE=en_US
ENV LC_ALL=en_US.utf8
ENV LANG=en_US.utf8
ENV TZ=Europe/Kiev

EXPOSE 31244 31245 33033 33034 33035

RUN bin/sh -c set -xe \
    && echo '#!/bin/sh' > /usr/sbin/policy-rc.d \ 
    && echo 'exit 101' >> /usr/sbin/policy-rc.d \
    && chmod +x /usr/sbin/policy-rc.d \
    && dpkg-divert --local --rename --add /sbin/initctl\
    && cp -a /usr/sbin/policy-rc.d /sbin/initctl \
    && sed -i 's/^exit.*/exit 0/' /sbin/initctl \
    && echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup \
    && echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean \
    && echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean \
    && echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean \
    && echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages \
    && echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes \
    && echo 'Apt::AutoRemove::SuggestsImportant "false";' > /etc/apt/apt.conf.d/docker-autoremove-suggestsln \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apt-get update \
    && apt-get install pkg-config curl git build-essential libssl-dev wget unzip -y \
    && wget https://gitlab.com/massalabs/massa/-/jobs/artifacts/testnet/download?job=build-linux -O massa.zip \
    && unzip m*.zip \
    && rm -f massa.zip \
    && cd massa \
    && rm -rf massa-client 

WORKDIR /massa/massa-node

CMD ["/massa/massa-node/massa-node"]

