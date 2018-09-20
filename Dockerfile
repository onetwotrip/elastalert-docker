FROM python:2-alpine

MAINTAINER OneTwoTrip DevOps Team, https://github.com/onetwotrip

ENV CONFIG_DIR /opt/config
ENV RULES_DIR /opt/rules
ENV LOG_DIR /opt/logs
ENV ELASTALERT_CONFIG ${CONFIG_DIR}/elastalert_config.yaml
ENV ELASTALERT_VERSION 0.1.32

ENV ELASTALERT_URL https://github.com/Yelp/elastalert/archive/v${ELASTALERT_VERSION}.zip

# Create directories.
RUN mkdir -p ${CONFIG_DIR} ${RULES_DIR} ${LOG_DIR}

# Install/Download deps and src
RUN apk add --no-cache --update python-dev gcc ca-certificates openssl openssl-dev musl-dev libffi-dev && \
    easy_install pip && \
    cd /usr/src/ && \
    wget ${ELASTALERT_URL} && \
    unzip *.zip && \
    rm *.zip

# Install Elastalert.
RUN cd /usr/src/elastalert-${ELASTALERT_VERSION} && \
    python setup.py install && \
    pip install -e . && \
    cp config.yaml.example ${ELASTALERT_CONFIG}

# Copy modules
COPY elastalert_modules /usr/src/elastalert-${ELASTALERT_VERSION}/elastalert_modules

# Clean up.
RUN apk del python-dev && \
    apk del musl-dev && \
    apk del libffi-dev && \
    apk del openssl-dev && \
    apk del gcc

VOLUME [ "${CONFIG_DIR}", "${RULES_DIR}", "${LOG_DIR}"]

CMD elastalert --config ${ELASTALERT_CONFIG} --verbose
