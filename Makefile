IMAGE_FILE?=image.yaml
COMMIT?=$(shell git rev-parse HEAD | cut -c1-8)
IMAGE_VERSION?=latest
REPO?=$(shell cat $(IMAGE_FILE) | grep "^name:" | cut -d' ' -f2)
DOGEN_VERSION?=2.0.1
DOCKER_BUILD_OPTS?=""
DOCKER?=docker

build: 
	echo "Running docker build $(REPO)"
	mkdir -p $(TMPDIR)/build/
	cp -r image.yaml $(TMPDIR)/
	cp -r build/* $(TMPDIR)/build/

	$(DOCKER) run -i --rm -v $(TMPDIR):/tmp/output:z -v ${CURDIR}/scripts:/tmp/scripts:z -v /etc/yum.repos.d/rhel-base-os.repo:/tmp/repos/rhel-base-os.repo:z jboss/dogen:$(DOGEN_VERSION) --verbos /tmp/output/$(IMAGE_FILE) --repo-files-dir /tmp/repos --scripts /tmp/scripts /tmp/output/build
	$(DOCKER) build $(DOCKER_BUILD_OPTS) -t $(REPO):$(COMMIT) $(TMPDIR)/build

push:
	$(DOCKER) tag $(REPO):$(COMMIT) $(DOCKER_REGISTRY)/$(REPO):$(COMMIT)
	$(DOCKER) push $(DOCKER_REGISTRY)/$(REPO):$(COMMIT)

snapshot:
	$(DOCKER) tag $(REPO):$(COMMIT) $(DOCKER_REGISTRY)/$(REPO):$(IMAGE_VERSION)
	$(DOCKER) push $(DOCKER_REGISTRY)/$(REPO):$(IMAGE_VERSION)

clean:
	rm -rf build
