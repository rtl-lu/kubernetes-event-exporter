DOCKER_REGISTRY_DOMAIN ?= ghcr.io
DOCKER_REGISTRY_PATH   ?= rtl-lu
REPOSITORY_PATH        ?= $(shell git config --local remote.origin.url | sed -n 's@.*/\([^.]*\)\.git@\1@p')
PROJECT                ?= ${REPOSITORY_PATH}
GIT_COMMIT             := $(shell git rev-parse --short HEAD)


build: IMG_NAME=exporter
build: DOCKERCONTEXT=.
build: DOCKERFILE=./Dockerfile
build: IMG=${DOCKER_REGISTRY_DOMAIN}/${DOCKER_REGISTRY_PATH}/${REPOSITORY_PATH}/$(IMG_NAME)
build: build-container push-container


build-container:
	docker build \
		--pull \
		--platform=linux/amd64 \
		--target prod \
		-t ${IMG}:${GIT_COMMIT} \
		-t ${IMG}:latest \
		-f ${DOCKERFILE} ${DOCKERCONTEXT}


push-container:
	docker push ${IMG}:${GIT_COMMIT}
	docker push ${IMG}:latest
