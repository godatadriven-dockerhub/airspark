FROM openjdk:8

ENV PYTHONDONTWRITEBYTECODE 1

ARG BUILD_DATE
ARG AIRFLOW_VERSION=1.10.5
ARG AIRFLOW_EXTRAS=async,crypto,jdbc,postgres,ssh,kubernetes

LABEL org.label-schema.name="Apache Airflow ${AIRFLOW_VERSION}" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=$AIRFLOW_VERSION

RUN set -x\
    && apt-get update \
    && apt-get -y purge python2.7-minimal \
    && apt-get install -y python3-pip python3-dev gcc g++ netcat git ca-certificates libpq-dev curl --no-install-recommends \
    && pip3 install setuptools \
    && pip3 install --no-cache-dir apache-airflow[$AIRFLOW_EXTRAS]==$AIRFLOW_VERSION werkzeug>=0.15.0 "marshmallow-sqlalchemy<=0.19.0" \
    && apt-get remove -y --purge gcc g++ git curl \
    && apt autoremove -y \
    && apt-get clean -y \
    && ln -s /usr/bin/python3 /usr/bin/python

ARG SPARK_VERSION=2.4.3

ENV SPARK_HOME /usr/spark
ENV PATH="/usr/spark/bin:${PATH}"

RUN wget -q "http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz" && \
    tar xzf "spark-${SPARK_VERSION}-bin-hadoop2.7.tgz" && \
    rm "spark-${SPARK_VERSION}-bin-hadoop2.7.tgz" && \
    mv "spark-${SPARK_VERSION}-bin-hadoop2.7" /usr/spark

COPY entrypoint.sh /scripts/
RUN chmod +x /scripts/entrypoint.sh

WORKDIR /root/airflow
VOLUME ["/root/airflow/dags", "/root/airflow/logs"]

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["--help"]
