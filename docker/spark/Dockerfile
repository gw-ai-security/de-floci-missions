FROM apache/spark:3.5.6-python3

USER root
ARG HADOOP_AWS_VERSION=3.3.4
ARG AWS_SDK_BUNDLE_VERSION=1.12.262
ARG ICEBERG_VERSION=1.7.2
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && curl -fsSLo /opt/spark/jars/hadoop-aws-${HADOOP_AWS_VERSION}.jar "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_AWS_VERSION}/hadoop-aws-${HADOOP_AWS_VERSION}.jar" \
    && curl -fsSLo /opt/spark/jars/aws-java-sdk-bundle-${AWS_SDK_BUNDLE_VERSION}.jar "https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_BUNDLE_VERSION}/aws-java-sdk-bundle-${AWS_SDK_BUNDLE_VERSION}.jar" \
    && curl -fsSLo /opt/spark/jars/iceberg-spark-runtime.jar "https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.5_2.12/${ICEBERG_VERSION}/iceberg-spark-runtime-3.5_2.12-${ICEBERG_VERSION}.jar" \
    && pip install --no-cache-dir boto3==1.39.3 pandas==2.3.1 pyarrow==20.0.0 \
    && rm -rf /var/lib/apt/lists/*

COPY spark-defaults.conf /opt/spark/conf/spark-defaults.conf
WORKDIR /workspace
