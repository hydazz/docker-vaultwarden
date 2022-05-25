# environment settings
ARG VERSION

FROM vaultwarden/server:${VERSION}-alpine as builder

RUN set -xe && \
	mkdir -p /out/usr/bin && \
	mv /vaultwarden /out/usr/bin && \
	mv \
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
	ROCKET_PORT="8080" \
	ROCKET_WORKERS="10" \
	SSL_CERT_DIR="/etc/ssl/certs" \
	DATA_FOLDER="/config" \
	LOG_FILE="/config/log/bitwarden.log"

RUN set -xe && \
	echo "**** install runtime packages ****" && \
	apk add --no-cache \
		openssl \
		postgresql-libs && \
	echo "**** cleanup ****" && \
	rm -rf \
		/tmp/*

COPY --from=builder /out /

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080 3012
VOLUME /config
