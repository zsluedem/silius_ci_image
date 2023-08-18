# build
FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get -y upgrade && apt-get install -y build-essential software-properties-common curl git clang libclang-dev libssl-dev
RUN add-apt-repository ppa:ethereum/ethereum && apt-get update && apt-get install -y solc

RUN curl -sL https://deb.nodesource.com/setup_14.x | sh -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y nodejs yarn

WORKDIR /rust

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

RUN /root/.cargo/bin/cargo install cargo-sort cargo-udeps

WORKDIR /silius_image
COPY ./silius .

RUN make fetch-thirdparty && make setup-thirdparty && cargo build --workspace