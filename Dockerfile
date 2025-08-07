 FROM alpine:latest AS builder

LABEL org.opencontainers.image.authors="clement.mangin@pm.me"
LABEL org.opencontainers.image.source="https://github.com/clementmangin/docker-libpostal"

RUN apk add --no-cache \
    git \
    build-base \
    curl \
    autoconf \
    automake \
    libtool \
    pkgconf

RUN git clone https://github.com/openvenues/libpostal /tmp/libpostal

WORKDIR /tmp/libpostal

RUN ./bootstrap.sh && \
    ./configure --datadir=/usr/local/share/libpostal && \
    make -j$(nproc) && \
    make install

FROM alpine:latest AS dist

COPY --from=builder /usr/local/lib/libpostal.so* /usr/local/lib/
COPY --from=builder /usr/local/share/libpostal /usr/local/share/libpostal
COPY --from=builder /usr/local/include/libpostal /usr/local/include/libpostal
COPY --from=builder /usr/local/bin/libpostal_data /usr/local/bin/

RUN ldconfig /etc/ld.so.conf.d

WORKDIR /
