GOOS ?= linux
GOARCH ?= amd64
CGO_ENABLED ?= 1
LDFLAGS += -s -w
BIN_NAME ?= static-ws
REPO ?= wesleimp/static-ws

ifeq ($(NOGIT),1)
  GIT_SUMMARY ?= Unknown
  GIT_BRANCH ?= Unknown
  GIT_MERGE ?= Unknown
else
  GIT_SUMMARY := $(shell git describe --tags --dirty --always)
  GIT_BRANCH := $(shell git symbolic-ref -q --short HEAD)
  GIT_MERGE := $(shell git rev-list --count --merges main)
endif

LDFLAGS += -X main.GitBranch=${GIT_BRANCH} -X main.GitSummary=${GIT_SUMMARY} -X main.GitMerge=${GIT_MERGE}

default: help

## build: builds the binaries
build:
	@echo GOOS       : $(GOOS)
	@echo GOARCH     : $(GOARCH)
	@echo LDFLAGS    : $(LDFLAGS)
	@echo CGO_ENABLED: $(CGO_ENABLED)
	CGO_ENABLED=$(CGO_ENABLED) GOOS=$(GOOS) GOARCH=$(GOARCH) go build -ldflags="${LDFLAGS}" -o bin/${BIN_NAME} main.go

## docker-build: builds the docker image
docker-build:
	docker build -t $(REPO):$(GIT_SUMMARY) .
	docker build -t $(REPO):latest .

## docker-push: push images to docker hub
docker-push:
	docker push $(REPO):$(GIT_SUMMARY)
	docker push $(REPO):latest

## clean: cleans bin folder
clean:
	@rm -rf bin/*

## deps: downloads mod dependencies
deps:
	@go mod download

## test: test all files recursively
test:
	@go test ./...

## vet: check for linting issues
vet:
	@go vet ./...

## help: show this help
help: Makefile
	@echo
	@echo " Choose a command run:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo

.PHONY: build help
