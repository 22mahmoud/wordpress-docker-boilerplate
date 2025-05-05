dev:
	$(MAKE) build-dev up-dev

build-dev:
	@docker compose -f compose.dev.yml build

up-dev:
	@docker compose -f compose.dev.yml up -d

down-dev:
	@docker compose -f compose.dev.yml down

workspace-dev:
	@docker compose -f compose.dev.yml exec -it workspace bash

prod:
	$(MAKE) build-prod up-prod

build-prod:
	@docker build -f docker/node/Dockerfile -t skin-theme-final:latest .
	@docker compose -f compose.prod.yml build

up-prod:
	@docker compose -f compose.prod.yml up -d

down-prod:
	@docker compose -f compose.prod.yml down

.PHONY: dev build-dev up-dev workspace-dev build-prod up-prod down-prod
