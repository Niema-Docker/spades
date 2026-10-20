# Minimal Docker image for SPAdes using Debian base
FROM debian:stable-slim
MAINTAINER Niema Moshiri <niemamoshiri@gmail.com>

# install SPAdes
RUN apt-get update && \
    apt-get install -y cmake g++ libbz2-dev make python3 wget && \
    wget -qO- "https://github.com/ablab/spades/releases/download/v4.3.0/SPAdes-4.3.0.tar.gz" | tar -zx && \
    cd SPAdes-* && \
    PREFIX=/usr/local ./spades_compile.sh && \
    cd .. && \
    rm -rf SPAdes-*
