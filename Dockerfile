# Use an Ubuntu-based image
FROM ubuntu:latest

# Install Kafka tools and required utilities
RUN apt-get update && apt-get install -y \
    wget \
    dnsutils \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Download and install Kafka tools
RUN wget https://packages.confluent.io/archive/7.0/confluent-oss-7.0.0.tar.gz && \
    tar -xvzf confluent-oss-7.0.0.tar.gz && \
    mv confluent-oss-7.0.0 /opt/confluent

# Set the entrypoint to bash
ENTRYPOINT ["/bin/bash"]

