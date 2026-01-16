
BINARY_NAME=ag-khoata
VERSION=1.0.0
BUILD_TIME=$(shell date +%FT%T%z)

# Default to empty if not set in environment or command line
OAUTH_CLIENT_ID ?= ""
OAUTH_CLIENT_SECRET ?= ""

LDFLAGS=-X main.Version=${VERSION} \
	-X main.BuildTime=${BUILD_TIME} \
	-X "github.com/phamminhkhoa2k4/khoata-tool/internal/auth.embeddedClientID=${OAUTH_CLIENT_ID}" \
	-X "github.com/phamminhkhoa2k4/khoata-tool/internal/auth.embeddedClientSecret=${OAUTH_CLIENT_SECRET}"

.PHONY: all build test clean run

all: build

build:
	go build -v -ldflags '${LDFLAGS}' -o ${BINARY_NAME} ./cmd/ag-khoata

test:
	go test -v ./...

clean:
	go clean
	rm -f ${BINARY_NAME}
	rm -f ${BINARY_NAME}.exe

run:
	go run ./cmd/ag-khoata
