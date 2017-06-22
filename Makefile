IMAGE_FILE?=image.yaml
COMMIT?=$(shell git rev-parse HEAD | cut -c1-8)
IMAGE_VERSION?=latest
REPO?=$(shell cat $(IMAGE_FILE) | grep "^name:" | cut -d' ' -f2)
DOCKER_BUILD_OPTS?=
DOCKER?=docker

build: 
	echo "Running docker build $(REPO)"
	mkdir -p /tmp/repos
	cp -rf /etc/yum.repos.d/rhel-base-os.repo /tmp/repos/
	dogen --repo-files-dir /tmp/repos --scripts $(CURDIR)/scripts --verbose $(IMAGE_FILE) build
	$(DOCKER) build $(DOCKER_BUILD_OPTS) -t $(REPO):$(COMMIT) $(CURDIR)/build

push:
	$(DOCKER) tag $(REPO):$(COMMIT) $(DOCKER_REGISTRY)/$(REPO):$(COMMIT)
	$(DOCKER) push $(DOCKER_REGISTRY)/$(REPO):$(COMMIT)

snapshot:
	$(DOCKER) tag $(REPO):$(COMMIT) $(DOCKER_REGISTRY)/$(REPO):$(IMAGE_VERSION)
	$(DOCKER) push $(DOCKER_REGISTRY)/$(REPO):$(IMAGE_VERSION)

clean:
	rm -rf build

.PHONY: build push snapshot clean
