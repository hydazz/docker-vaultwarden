
FROM vaultwarden/web-vault@sha256:df7f12b1e22bf0dfc1b6b6f46921b4e9e649561931ba65357c1eb1963514b3b5 as vault

########################## BUILD IMAGE  ##########################
FROM blackdex/rust-musl:x86_64-musl-stable-1.61.0 as build

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    TZ=UTC \
    TERM=xterm-256color \
    CARGO_HOME="/root/.cargo" \
    USER="root"
ARG DB=sqlite,mysql,postgresql,enable_mimalloc \
	VERSION

RUN \
    mkdir -pv "${CARGO_HOME}" && \
    rustup set profile minimal && \
    cargo new --bin /app && \
    cd /app && \
	mkdir -p /tmp/vaultwarden && \
	curl -o \
		/tmp/vaultwarden.tar.gz -L \
		"https://github.com/dani-garcia/vaultwarden/archive/${VERSION}.tar.gz" && \
	tar xf \
		/tmp/vaultwarden.tar.gz -C \
		/tmp/vaultwarden --strip-components=1 && \
    mv \
        /tmp/vaultwarden/Cargo.* \
        /tmp/vaultwarden/rust-toolchain\
        /tmp/vaultwarden/build.rs \
    ./ && \
    rustup target add x86_64-unknown-linux-musl && \
    cargo build --features ${DB} --release --target=x86_64-unknown-linux-musl && \
    find . -not -path "./target*" -delete && \
    mv /tmp/vaultwarden/* ./ && \
    touch src/main.rs && \
    cargo build --features ${DB} --release --target=x86_64-unknown-linux-musl && \
    touch /vaultwarden_docker_persistent_volume_check