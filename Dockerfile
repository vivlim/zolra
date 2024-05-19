FROM rust:slim-bookworm AS builder

RUN apt-get update -y && \
  apt-get install -y make g++ libssl-dev && \
  rustup target add x86_64-unknown-linux-gnu

WORKDIR /app
COPY . .

RUN cargo build --release --target x86_64-unknown-linux-gnu

FROM gcr.io/distroless/cc-debian12

COPY --from=busybox:1.35.0-uclibc /bin/sh /bin/sh

COPY --from=builder /app/target/x86_64-unknown-linux-gnu/release/zolra /bin/zolra
COPY entrypoint.sh /entrypoint.sh

RUN mkdir -p /github/workspace

ENTRYPOINT [ "/bin/sh", "/entrypoint.sh" ]
