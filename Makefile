TAG ?= 2025
IMAGE = tahv/mayapy:${TAG}

.PHONY: interactive  ## Run an interactive docker container
interactive:
	docker build --platform linux/amd64 -t ${IMAGE} ${TAG}
	docker run --rm -it ${IMAGE}
