FROM python:2-alpine

MAINTAINER Dmitry Shmelev, https://github.com/dshmelev

ENV CONFIG_DIR /opt/config
ENV RULES_DIR /opt/rules
ENV LOG_DIR /opt/logs
ENV ELASTALERT_HOME /opt/elastalert

ENV ELASTALERT_CONFIG ${CONFIG_DIR}/elastalert_config.yaml

ENV ELASTALERT_URL https://github.com/Yelp/elastalert/archive/master.zip

WORKDIR /opt

RUN apk add --no-cache --update python-dev gcc ca-certificates openssl openssl-dev musl-dev libffi-dev && \
    easy_install pip && \
    wget ${ELASTALERT_URL} && \
    unzip *.zip && \
    rm *.zip && \
    mv elastalert* ${ELASTALERT_HOME}

WORKDIR ${ELASTALERT_HOME}

# Install Elastalert.
RUN python setup.py install && \
    pip install -e . && \
    pip uninstall twilio --yes && \
    pip install twilio==6.0.0

# Create directories.
RUN mkdir -p ${CONFIG_DIR} && \
    mkdir -p ${RULES_DIR} && \
    mkdir -p ${LOG_DIR} && \
    cp ${ELASTALERT_HOME}/config.yaml.example ${ELASTALERT_CONFIG}

# Clean up.
RUN apk del python-dev && \
    apk del musl-dev && \
    apk del libffi-dev && \
    apk del openssl-dev && \
    apk del gcc

VOLUME [ "${CONFIG_DIR}", "${RULES_DIR}", "${LOG_DIR}"]

CMD python ${ELASTALERT_HOME}/elastalert/elastalert.py --config ${ELASTALERT_CONFIG} --verbose
