FROM golang:1.15.2 as proto

ENV DEBIAN_FRONTEND=noninteractive

ARG PROTO_VERSION=3.11.4
ARG GRPCWEB_VERSION=1.0.7

WORKDIR /work

RUN apt-get -qq update && apt-get -qq install -y \
    unzip

RUN curl -sSL https://github.com/protocolbuffers/protobuf/releases/download/v${PROTO_VERSION}/protoc-${PROTO_VERSION}-linux-x86_64.zip -o protoc.zip && \
    unzip -qq protoc.zip && \
    cp ./bin/protoc /usr/local/bin/protoc && \
    cp -r ./include /usr/local

RUN curl -sSL https://github.com/grpc/grpc-web/releases/download/${GRPCWEB_VERSION}/protoc-gen-grpc-web-${GRPCWEB_VERSION}-linux-x86_64 -o /usr/local/bin/protoc-gen-grpc-web && \
    chmod +x /usr/local/bin/protoc-gen-grpc-web

RUN go get -u github.com/golang/protobuf/protoc-gen-go

FROM node:12.16.1-alpine3.11 as frontend

WORKDIR /work
RUN yarn

FROM golang:1.15.2-alpine3.12 as backend

ENV GO11MODULE=on

WORKDIR /go/src/app

RUN apk add --no-cache --update \
    git

RUN go get github.com/pilu/fresh

FROM envoyproxy/envoy:v1.17-latest as envoy

WORKDIR /work

COPY ./envoy.yaml /work/envoy.yaml
CMD /usr/local/bin/envoy -c /work/envoy.yaml
EXPOSE 48080