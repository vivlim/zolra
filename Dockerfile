FROM --platform=$TARGETPLATFORM rust:slim-bookworm AS builder

ARG TARGETARCH
RUN echo "Target arch: $TARGETARCH"

RUN apt-get update -y && \
  apt-get install -y make g++ libssl-dev && \
  rustup target add "$(case "$TARGETARCH" in amd64) echo x86_64 ;; arm64) echo aarch64 ;; esac)-unknown-linux-gnu"

WORKDIR /app
COPY . .

RUN cargo build --release --target "$(case "$TARGETARCH" in amd64) echo x86_64 ;; arm64) echo aarch64 ;; esac)-unknown-linux-gnu"
RUN mv "/app/target/$(case "$TARGETARCH" in amd64) echo x86_64 ;; arm64) echo aarch64 ;; esac)-unknown-linux-gnu/release/zolra" /app/target

FROM gcr.io/distroless/cc-debian12

COPY --from=builder /app/target/zolra /bin/zolra

ENTRYPOINT [ "/bin/zolra" ]
