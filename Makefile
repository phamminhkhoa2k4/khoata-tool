
BINARY_NAME=ag-khoata
VERSION=1.0.0
BUILD_TIME=$(shell date +%FT%T%z)

.PHONY: all build test clean run

all: build

build:
	go build -v -ldflags "-X main.Version=${VERSION} -X main.BuildTime=${BUILD_TIME}" -o ${BINARY_NAME} ./cmd/ag-khoata

test:
	go test -v ./...

clean:
	go clean
	rm -f ${BINARY_NAME}
	rm -f ${BINARY_NAME}.exe

run:
	go run ./cmd/ag-khoata
