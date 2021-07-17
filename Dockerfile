# Minimal Docker image for SPAdes v3.15.2 using Alpine base
FROM alpine:3.13.5
MAINTAINER Niema Moshiri <niemamoshiri@gmail.com>

# install SPAdes
RUN apk update && \
    apk add bash bzip2-dev g++ libexecinfo-dev make python3 zlib-dev && \ #musl-dev && \
    wget -qO- "https://github.com/ablab/spades/releases/download/v3.15.2/SPAdes-3.15.2.tar.gz" | tar -zx && \
    cd SPAdes-* && \
    # Alpine needs <stdint.h> to be included to have int32_t defined. I made a pull request to SPAdes, so remove this in the future
    sed -i '1i#include <stdint.h>' ext/src/bamtools/api/internal/io/pbgzf/util.c && \
    sed -i 's/#include "k_range.hpp"/#include <cstdint>\n#include "k_range.hpp"/g' src/common/sequence/seq_common.hpp && \
    # u_int64_t is not standard, but uint64_t is
    sed -i 's/u_int64_t/uint64_t/g' src/common/sequence/seq_common.hpp && \
    PREFIX=/usr/local ./spades_compile.sh && \
    cd .. && \
    rm -rf SPAdes-*
    
    
    wget -qO- "https://mafft.cbrc.jp/alignment/software/mafft-7.475-without-extensions-src.tgz" | tar -zx && \
    cd mafft-*/core && \
    make clean && \
    make && \
    make install && \
    cd ../.. && \
    rm -rf mafft-*
