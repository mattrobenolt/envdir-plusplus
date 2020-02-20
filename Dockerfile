FROM golang:1.13

RUN mkdir -p /usr/src/envdir++
WORKDIR /usr/src/envdir++

COPY go.mod ./
RUN go mod download

COPY . ./

ENV PLATFORMS linux/amd64 darwin/amd64

CMD set -ex; \
    for platform in $PLATFORMS; do \
        GOOS=${platform%/*} GOARCH=${platform##*/} go build -v -o bin/envdir++-${platform%/*}-${platform##*/} -ldflags="-s -w" ./...; \
    done; \
    ls -l bin/
