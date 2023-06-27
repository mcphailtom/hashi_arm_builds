FROM ubuntu:jammy as builder

ARG GO_VERSION="1.20.5"
ARG RELEASE_VERSION="v1.5.6"
ENV HOME=/root
ENV GOPATH=${HOME}/go
ENV GOBIN=${HOME}/go/bin
ENV GOROOT=/usr/local/go
ENV SRC_HOME=${HOME}/src
ENV NOMAD_HOME=${SRC_HOME}/nomad
ENV PATH="$PATH:/usr/local/go/bin:${HOME}/go/bin"

RUN apt-get update && \
    apt-get install -y git build-essential curl gcc-arm-linux-gnueabi gcc-aarch64-linux-gnu

RUN curl -sSL https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz | tar -C /usr/local -xz && \
    mkdir -p ${GOPATH}/src ${GOPATH}/bin && chmod -R 777 ${GOPATH}

WORKDIR ${SRC_HOME}
RUN git clone --branch ${RELEASE_VERSION} https://github.com/hashicorp/nomad.git ${NOMAD_HOME}

WORKDIR $NOMAD_HOME
COPY nomad.goreleaser.yml "${NOMAD_HOME}/.goreleaser.yml"
RUN go install github.com/goreleaser/goreleaser@latest

RUN goreleaser --skip-validate --clean --skip-publish
