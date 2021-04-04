# environment settings
ARG VERSION

FROM bitwardenrs/server:${VERSION}-alpine as builder

RUN set -xe && \
	mkdir -p /out/usr/bin && \
	mv /bitwarden_rs /out/usr/bin && \
	mv \
		/Rocket.toml \
		/web-vault \
		/out

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# runtime stage
FROM vcxpz/baseimage-alpine:latest

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Bitwarden version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hydaz"

# environment settings
ENV ROCKET_ENV="staging" \
	ROCKET_PORT="80" \
	ROCKET_WORKERS="10" \
	SSL_CERT_DIR="/etc/ssl/certs" \
	DATA_FOLDER="/config"

RUN set -xe && \
	echo "**** install runtime packages ****" && \
	apk add --no-cache \
		curl \
		openssl \
		postgresql-libs \
		sqlite && \
	echo "**** cleanup ****" && \
	rm -rf \
		/tmp/*

COPY --from=builder /out /

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80 3012
VOLUME /config
