FROM ubuntu:jammy as builder

ARG go_version="go1.20.5.linux-amd64"
ARG vault_version="v1.14.0"
ENV HOME=/root
ENV GOPATH=${HOME}/go
ENV GOBIN=${HOME}/go/bin
ENV GOROOT=/usr/local/go
ENV SRC_HOME=${HOME}/src
ENV VAULT_HOME=${SRC_HOME}/vault
ENV PATH="$PATH:/usr/local/go/bin:${HOME}/go/bin"

RUN apt-get update && \
    apt-get install -y git build-essential curl

RUN curl -sSL https://dl.google.com/go/${go_version}.tar.gz | tar -C /usr/local -xz && \
    mkdir -p ${GOPATH}/src ${GOPATH}/bin && chmod -R 777 ${GOPATH}

WORKDIR ${SRC_HOME}
RUN git clone --branch ${vault_version} https://github.com/hashicorp/vault.git ${VAULT_HOME}

WORKDIR $VAULT_HOME
COPY vault.goreleaser.yml "${VAULT_HOME}/.goreleaser.yml"
RUN go install github.com/goreleaser/goreleaser@latest

RUN goreleaser --skip-validate --clean --skip-publish
