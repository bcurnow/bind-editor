#!/usr/bin/make

SHELL := /bin/bash
currentDir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
imageName := $(notdir $(patsubst %/,%,$(dir $(currentDir))))
dockerOpts := --name $(imageName) --rm ${imageName}:latest
dockerRegistry := devpi.local:443

docker-build:
	docker build \
	  -t ${imageName}:latest  \
	  ${currentDir}

docker-build-no-cache:
	docker build \
	  --no-cache \
	  -t ${imageName}:latest  \
	  ${currentDir}

docker-run:
	docker run -d ${dockerOpts}

docker-run-it:
	docker run ${dockerOpts}

docker-start: docker-run

docker-stop:
	docker stop ${imageName} 

docker-restart: docker-stop docker-start

docker-logs:
	docker logs ${imageName}

docker-logs-f:
	docker logs --follow ${imageName}

docker-shell:
	docker exec -it ${imageName} /bin/bash

all: docker-build docker-stop docker-run docker-logs

docker-publish:
ifndef version
	@echo "Must specify 'version' when publishing."
	exit 1
endif
	docker build \
	  -t ${dockerRegistry}/${imageName}:${version} \
	  ${currentDir} 

	docker push ${dockerRegistry}/${imageName}:${version}
