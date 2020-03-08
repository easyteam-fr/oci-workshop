SHELL = /bin/bash
MAKEFLAGS = "-s"
.DEFAULT_GOAL := install

REGISTRY = fra.ocir.io
USERNAME = nomad/gregory.guillou@resetlogs.com
REPOSITORY = nomad
TOOL = oraclecode
VERSION := $(shell grep "\"version\"" package.json |cut -d'"' -f4)

# allow to override terraform binary
ifndef DOCKER
DOCKER = docker
endif

undeploy:
	@. ./.env && export VERSION=$(VERSION) && \
	 export BASE64_TWITTER_CONSUMER_KEY="$$(echo -n $$TWITTER_CONSUMER_KEY | base64)" && \
	 export BASE64_TWITTER_CONSUMER_SECRET="$$(echo -n $$TWITTER_CONSUMER_SECRET | base64)" && \
	 export BASE64_TWITTER_ACCESS_TOKEN_KEY="$$(echo -n $$TWITTER_ACCESS_TOKEN_KEY | base64)" && \
	 export BASE64_TWITTER_ACCESS_TOKEN_SECRET="$$(echo -n $$TWITTER_ACCESS_TOKEN_SECRET | base64)" && \
	 export BASE64_HUBOT_SLACK_TOKEN="$$(echo -n $$HUBOT_SLACK_TOKEN | base64)" && \
	 envsubst < kube.yaml | kubectl delete -f - || true 

deploy:
	@. ./.env && export VERSION=$(VERSION) && \
	 export BASE64_TWITTER_CONSUMER_KEY="$$(echo -n $$TWITTER_CONSUMER_KEY | base64)" && \
	 export BASE64_TWITTER_CONSUMER_SECRET="$$(echo -n $$TWITTER_CONSUMER_SECRET | base64)" && \
	 export BASE64_TWITTER_ACCESS_TOKEN_KEY="$$(echo -n $$TWITTER_ACCESS_TOKEN_KEY | base64)" && \
	 export BASE64_TWITTER_ACCESS_TOKEN_SECRET="$$(echo -n $$TWITTER_ACCESS_TOKEN_SECRET | base64)" && \
	 export BASE64_HUBOT_SLACK_TOKEN="$$(echo -n $$HUBOT_SLACK_TOKEN | base64)" && \
	 envsubst < kube.yaml | kubectl apply -f - || true

redeploy: undeploy deploy

login:
	@. ./.env && echo "$$REGISTRY_AUTH_KEY" | docker login \
	  --username $(USERNAME) --password-stdin $(REGISTRY)

clean:
	@$(DOCKER) rmi $(REGISTRY)/$(REPOSITORY)/$(TOOL):$(VERSION)

build:
	@$(DOCKER) build -t $(REGISTRY)/$(REPOSITORY)/$(TOOL):$(VERSION) .

install: login build
	@$(DOCKER) push $(REGISTRY)/$(REPOSITORY)/$(TOOL):$(VERSION)

pull: login 
	@$(DOCKER) pull $(REGISTRY)/$(REPOSITORY)/$(TOOL):$(VERSION)

.PHONY: build clean install login pull deploy redeploy undeploy
