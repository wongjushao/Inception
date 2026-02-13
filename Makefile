# Inception Makefile

include srcs/.env

COMPOSE_FILE = srcs/docker-compose.yml

all: up

build:
	@docker compose -f $(COMPOSE_FILE) build

build-nocache:
	@docker compose -f $(COMPOSE_FILE) build --no-cache

up:
	@mkdir -p $(DATA_PATH)/mysql $(DATA_PATH)/wordpress secrets/ssl
	@docker compose -f $(COMPOSE_FILE) up -d
	@echo "Access your site at: https://$(DOMAIN_NAME)"
	@echo "If it does not resolve, add this on the host:"
	@echo "  echo '127.0.0.1 $(DOMAIN_NAME)' | sudo tee -a /etc/hosts"

start: build up

down:
	@docker compose -f $(COMPOSE_FILE) down

clean:
	@docker compose -f $(COMPOSE_FILE) down -v

fclean: clean
	@docker compose -f $(COMPOSE_FILE) down -v --rmi all
	@rm -rf $(DATA_PATH)/mysql $(DATA_PATH)/wordpress secrets/ssl

re: fclean build-nocache up

status:
	@docker compose -f $(COMPOSE_FILE) ps

logs:
	@docker compose -f $(COMPOSE_FILE) logs -f

restart: down up

.PHONY: all build up start down clean fclean re status logs restart