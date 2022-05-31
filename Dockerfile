# environment settings
FROM vaultwarden/web-vault@sha256:df7f12b1e22bf0dfc1b6b6f46921b4e9e649561931ba65357c1eb1963514b3b5 as vault

FROM blackdex/rust-musl:x86_64-musl-stable-1.61.0 as builder

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    TZ=UTC \
    TERM=xterm-256color \
    CARGO_HOME="/root/.cargo" \
    USER="root"

RUN mkdir -pv "${CARGO_HOME}" \
    && rustup set profile minimal

RUN USER=root cargo new --bin /app
WORKDIR /app

COPY ./Cargo.* ./
COPY ./rust-toolchain ./rust-toolchain
COPY ./build.rs ./build.rs

RUN rustup target add x86_64-unknown-linux-musl

ARG DB=sqlite,mysql,postgresql,enable_mimalloc

RUN cargo build --features ${DB} --release --target=x86_64-unknown-linux-musl \
    && find . -not -path "./target*" -delete

COPY . .

RUN touch src/main.rs

RUN cargo build --features ${DB} --release --target=x86_64-unknown-linux-musl

RUN touch /vaultwarden_docker_persistent_volume_check

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# runtime stage
FROM vcxpz/baseimage-alpine:latest

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Vaultwarden version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hydaz"

# environment settings
ENV ROCKET_PROFILE="release" \
	ROCKET_PORT="80" \
	ROCKET_ADDRESS="0.0.0.0" \
	SSL_CERT_DIR="/etc/ssl/certs" \
	DATA_FOLDER="/config" \
	LOG_FILE="/config/log/vaultwarden.log"

RUN set -xe && \
	echo "**** install runtime packages ****" && \
	apk add --no-cache \
		openssl \
		postgresql-libs && \
	echo "**** cleanup ****" && \
	rm -rf \
		/tmp/*

COPY --from=vault /web-vault ./web-vault
COPY --from=builder /vaultwarden_docker_persistent_volume_check /data/vaultwarden_docker_persistent_volume_check
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/vaultwarden .

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80 3012
VOLUME /config
