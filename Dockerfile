FROM ubuntu:18.04

MAINTAINER OneTwoTrip DevOps Team, https://github.com/onetwotrip

ENV LANG C.UTF-8
ENV CONFIG_DIR /opt/config
ENV RULES_DIR /opt/rules
ENV LOG_DIR /opt/logs
ENV ELASTALERT_CONFIG ${CONFIG_DIR}/elastalert_config.yaml
ENV ELASTALERT_VERSION 0.2.1

ENV ELASTALERT_URL https://github.com/Yelp/elastalert/archive/v${ELASTALERT_VERSION}.tar.gz

# Create directories.
RUN mkdir -p ${CONFIG_DIR} ${RULES_DIR} ${LOG_DIR}

# Install/Download deps and src
RUN apt-get update && apt-get upgrade -y
RUN apt-get -y install build-essential python3.6 python3.6-dev python3-pip libssl-dev git wget
RUN cd /usr/src/ && \
    wget ${ELASTALERT_URL} && \
    tar -xvzf *.tar.gz && \
    rm *.tar.gz

# Install Elastalert
RUN cd /usr/src/elastalert-${ELASTALERT_VERSION} && \
    pip3 install "setuptools>=11.3" && \
    python3 setup.py install && \
    cp config.yaml.example ${ELASTALERT_CONFIG}

# Copy modules
COPY elastalert_modules /usr/src/elastalert-${ELASTALERT_VERSION}/elastalert_modules

VOLUME [ "${CONFIG_DIR}", "${RULES_DIR}", "${LOG_DIR}" ]
WORKDIR /usr/src/elastalert-${ELASTALERT_VERSION}

CMD elastalert --config ${ELASTALERT_CONFIG} --verbose
