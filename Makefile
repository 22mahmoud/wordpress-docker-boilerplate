dev:
	$(MAKE) up-dev composer-install-dev

build-dev:
	@docker compose -f compose.dev.yml build

up-dev:
	@docker compose -f compose.dev.yml up -d

down-dev:
	@docker compose -f compose.dev.yml down

composer-install-dev:
	@docker compose -f compose.dev.yml exec -it workspace bash -c "composer install"

workspace-dev:
	@docker compose -f compose.dev.yml exec -it workspace bash

.PHONY: dev build-dev up-dev composer-install-dev workspace
