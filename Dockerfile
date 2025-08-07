 FROM --platform=$BUILDPLATFORM alpine:latest AS builder

LABEL org.opencontainers.image.authors="clement.mangin@pm.me"
LABEL org.opencontainers.image.source="https://github.com/clementmangin/docker-libpostal"

ARG TARGETARCH

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
    CONFIG_OPTS="" && \
    if [ "$TARGETARCH" = "arm64" ]; then CONFIG_OPTS="--disable-sse2"; fi && \
    ./configure $CONFIG_OPTS --datadir=/usr/local/share/libpostal && \
    make -j$(nproc) && \
    make install

FROM --platform=$BUILDPLATFORM alpine:latest AS dist

COPY --from=builder /usr/local/lib/libpostal.so* /usr/local/lib/
COPY --from=builder /usr/local/share/libpostal /usr/local/share/libpostal
COPY --from=builder /usr/local/include/libpostal /usr/local/include/libpostal
COPY --from=builder /usr/local/bin/libpostal_data /usr/local/bin/

RUN ldconfig /etc/ld.so.conf.d

WORKDIR /
