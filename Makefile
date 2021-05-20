IMAGE_NAME ?= authz-broker
PACKAGES=$(shell go list ./... | sed -r 's/.*?\/([^\/]+)$$/.\/\1/')
VERSION ?= 1.0.1
IMAGE_VERSION ?= $(VERSION)

.PHONY: all binary test image vet lint clean

SRCS = $(shell git ls-files '*.go' | grep -v '^vendor/')

default: binary

all: image
	docker build .

fmt:
	gofmt -w $(SRCS)

vet:
	@ go vet ${PACKAGES}

lint:
	@ go get -v golang.org/x/lint/golint
	$(foreach file,$(SRCS),golint $(file) || exit;)

image: test
	docker build -t ${IMAGE_NAME}:${IMAGE_VERSION} .

binary: lint fmt vet
	mkdir -p bin/
	CGO_ENABLED=0 go build -o bin/authz-broker --ldflags "-X \"main.version=$(VERSION)\"" -a -installsuffix cgo ./broker/main.go
	strip -sg bin/authz-broker

test: binary
	go test -v ${PACKAGES}

clean:
	rm -rf bin/
