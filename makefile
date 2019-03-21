SHELL := bash
DOCKER_REPO_NAME := quay.io/mittwald/newrelic-daemon
DEBIAN_RELEASE := 8.11
NEWRELIC_DAEMON_VERSION := 8.6.0.238

.PHONY: dockerbuild dockertag dockerpush

dockerbuild:
	docker build --pull --no-cache --build-arg DEBIAN_RELEASE=$(DEBIAN_RELEASE) --build-arg NEWRELIC_DAEMON_VERSION=$(NEWRELIC_DAEMON_VERSION) -t $(DOCKER_REPO_NAME):latest .
dockertag:
	docker tag $(DOCKER_REPO_NAME):latest $(DOCKER_REPO_NAME):$(NEWRELIC_DAEMON_VERSION)
	docker tag $(DOCKER_REPO_NAME):latest $(DOCKER_REPO_NAME):$(NEWRELIC_DAEMON_VERSION)-debian$(DEBIAN_RELEASE)
dockerpush:
	docker push $(DOCKER_REPO_NAME):latest 
	docker push $(DOCKER_REPO_NAME):$(NEWRELIC_DAEMON_VERSION)
	docker push $(NEWRELIC_DAEMON_VERSION)-debian$(DEBIAN_RELEASE)
dockerrelease:
	make dockerbuild
	make dockertag
	make dockerpush
