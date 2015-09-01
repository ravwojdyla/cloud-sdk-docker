FROM ubuntu:trusty
MAINTAINER Rafal Wojdyla "ravwojdyla@gmail.com"

# Install java:
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get update && \
    apt-get install -y --force-yes --no-install-recommends python-software-properties software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y --force-yes --no-install-recommends oracle-java8-installer && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

RUN apt-get update && apt-get install -y -qq --no-install-recommends \
    wget \
    unzip \
    python \
    php5-mysql \
    php5-cli \
    php5-cgi \
    openssh-client \
    python-openssl && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip && \
    unzip google-cloud-sdk.zip && rm google-cloud-sdk.zip
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1

RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --disable-installation-options
RUN google-cloud-sdk/bin/gcloud --quiet components update pkg-go pkg-python pkg-java preview alpha beta app
RUN google-cloud-sdk/bin/gcloud --quiet config set component_manager/disable_update_check true

RUN mkdir /.ssh

ENV PATH /google-cloud-sdk/bin:$PATH
ENV HOME /

VOLUME ["/.config"]
CMD ["/bin/bash"]
