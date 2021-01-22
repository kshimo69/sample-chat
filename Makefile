SHELL	= bash

export COMPOSE_DOCKER_CLI_BUILD=1

.PHONY: proto
proto:
	docker-compose run --rm proto

.PHONY: build
build:
	docker-compose build
	docker-compose run --rm frontend yarn

.PHONY: start
start:
	docker-compose up
