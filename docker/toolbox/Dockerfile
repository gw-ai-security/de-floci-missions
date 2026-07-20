FROM node:22.17.0-bookworm-slim AS node-runtime

FROM python:3.12.11-slim-bookworm

ARG TARGETARCH
ARG AWS_CLI_VERSION=2.27.49
ARG OPENTOFU_VERSION=1.12.4
ARG KUBECTL_VERSION=1.32.6
ARG HELM_VERSION=4.2.3

COPY --from=node-runtime /usr/local/ /usr/local/

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl unzip git jq less groff openssh-client \
       postgresql-client redis-tools kafkacat openjdk-17-jre-headless build-essential libpq-dev \
    && case "$TARGETARCH" in amd64) aws_arch=x86_64; bin_arch=amd64 ;; arm64) aws_arch=aarch64; bin_arch=arm64 ;; *) exit 1 ;; esac \
    && curl -fsSLo /tmp/awscliv2.zip "https://awscli.amazonaws.com/awscli-exe-linux-${aws_arch}-${AWS_CLI_VERSION}.zip" \
    && unzip -q /tmp/awscliv2.zip -d /tmp && /tmp/aws/install \
    && curl -fsSLo /tmp/tofu.zip "https://github.com/opentofu/opentofu/releases/download/v${OPENTOFU_VERSION}/tofu_${OPENTOFU_VERSION}_linux_${bin_arch}.zip" \
    && unzip -q /tmp/tofu.zip -d /usr/local/bin tofu \
    && curl -fsSLo /usr/local/bin/kubectl "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${bin_arch}/kubectl" \
    && curl -fsSLo /tmp/helm.tgz "https://get.helm.sh/helm-v${HELM_VERSION}-linux-${bin_arch}.tar.gz" \
    && tar -xzf /tmp/helm.tgz -C /tmp && mv "/tmp/linux-${bin_arch}/helm" /usr/local/bin/helm \
    && chmod +x /usr/local/bin/kubectl /usr/local/bin/helm /usr/local/bin/tofu \
    && npm install --global aws-cdk@2.1132.0 \
    && pip install --no-cache-dir \
       aws-sam-cli==1.163.0 boto3==1.39.3 botocore==1.39.3 \
       pytest==8.4.1 testcontainers==4.10.0 \
       pandas==2.3.1 pyarrow==20.0.0 polars==1.31.0 duckdb==1.3.2 \
       sqlalchemy==2.0.41 psycopg[binary]==3.2.9 confluent-kafka==2.10.1 \
       requests==2.32.4 pydantic==2.11.7 pandera==0.24.0 \
    && apt-get purge -y build-essential libpq-dev \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /workspace
CMD ["bash"]
