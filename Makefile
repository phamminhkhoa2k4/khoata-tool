
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

.PHONY: all build test clean run release

all: build

build:
	go build -v -ldflags '${LDFLAGS}' -o ${BINARY_NAME} ./cmd/ag-khoata

release: clean
	mkdir -p release
	# Windows AMD64
	GOOS=windows GOARCH=amd64 go build -v -ldflags '${LDFLAGS}' -o release/${BINARY_NAME}-windows-amd64.exe ./cmd/ag-khoata
	# Linux AMD64
	GOOS=linux GOARCH=amd64 go build -v -ldflags '${LDFLAGS}' -o release/${BINARY_NAME}-linux-amd64 ./cmd/ag-khoata
	# macOS AMD64 (Intel)
	GOOS=darwin GOARCH=amd64 go build -v -ldflags '${LDFLAGS}' -o release/${BINARY_NAME}-darwin-amd64 ./cmd/ag-khoata
	# macOS ARM64 (Apple Silicon)
	GOOS=darwin GOARCH=arm64 go build -v -ldflags '${LDFLAGS}' -o release/${BINARY_NAME}-darwin-arm64 ./cmd/ag-khoata

test:
	go test -v ./...

clean:
	go clean
	rm -f ${BINARY_NAME}
	rm -f ${BINARY_NAME}.exe
	rm -rf release

run:
	go run ./cmd/ag-khoata
