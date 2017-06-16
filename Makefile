IMAGE_FILE?=image.yaml
COMMIT?=latest
IMAGE_VERSION?=latest
REPO?=$(shell cat $(IMAGE_FILE) | grep "^name:" | cut -d' ' -f2)
DOGEN_VERSION?=2.0.1

all: 
	echo "Running docker build $(REPO)"
	docker run -i --rm -v ${CURDIR}:/tmp/output:z -v ${CURDIR}/scripts:/tmp/scripts:z jboss/dogen:$(DOGEN_VERSION) --verbos /tmp/output/$(IMAGE_FILE) --scripts /tmp/scripts /tmp/output/build
	docker build -t $(REPO):$(IMAGE_VERSION) build

clean:
	rm -rf build
