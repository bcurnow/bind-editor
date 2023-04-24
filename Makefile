#!/usr/bin/make

SHELL := /bin/bash
currentDir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
imageName := $(notdir $(patsubst %/,%,$(dir $(currentDir))))
dockerOpts := --name $(imageName) --rm ${imageName}:latest
dockerRegistry := registry.internal.curnowtopia.com
platforms := linux/amd64,linux/arm/v7

docker-build:
	docker buildx build \
          --platform ${platforms} \
          --output type=image,name=${imageName} \
	  --tag ${imageName}:latest  \
	  ${currentDir}

docker-build-no-cache:
	docker buildx build \
	  --no-cache \
          --platform ${platforms} \
          --output type=image \
	  --tag ${imageName}:latest  \
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
	docker buildx build \
          --platform ${platforms} \
	  --push \
	  --tag ${dockerRegistry}/${imageName}:${version} \
	  ${currentDir}

	# Create git tag as well
	git tag -a -m "Release ${version}" v${version}
	git push origin v${version}
