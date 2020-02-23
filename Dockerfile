# doc
FROM openjdk:8u242-jdk-stretch

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
		asciidoctor=1.5.4-2 \
		docbook-xsl-ns=1.79.1+dfsg-2 \
		docbook5-xml=5.0-2 \
		graphviz=2.38.0-17 \
		make=4.1-9.1 \
		pandoc=1.17.2~dfsg-3 \
		&& rm -rf /var/lib/apt/lists/*

ENV ANT_VERSION=1.10.7
ENV ANT_HOME=/opt/ant

# change to tmp folder
WORKDIR /tmp

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Download and extract apache ant to opt folder
RUN wget -q --no-check-certificate --no-cookies http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
  && wget -q --no-check-certificate --no-cookies http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz.sha512 \
  && echo "$(cat apache-ant-${ANT_VERSION}-bin.tar.gz.sha512) apache-ant-${ANT_VERSION}-bin.tar.gz" | sha512sum -c \
  && tar -zxf apache-ant-${ANT_VERSION}-bin.tar.gz -C /opt/ \
  && ln -s /opt/apache-ant-${ANT_VERSION} /opt/ant \
  && rm -f apache-ant-${ANT_VERSION}-bin.tar.gz \
  && rm -f apache-ant-${ANT_VERSION}-bin.tar.gz.sha512

# add executables to path
RUN update-alternatives --install "/usr/bin/ant" "ant" "/opt/ant/bin/ant" 1 && \
    update-alternatives --set "ant" "/opt/ant/bin/ant"

ENV PANDOC_VERSION=2.9.2
RUN wget -q --no-check-certificate --no-cookies https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-1-amd64.deb \
  && dpkg -i pandoc-${PANDOC_VERSION}-1-amd64.deb \
  && rm -f pandoc-${PANDOC_VERSION}-1-amd64.deb
