# Inception Makefile

ENV_FILE = srcs/.env
ENV_EXAMPLE = srcs/.env.example

-include srcs/.env

COMPOSE_FILE = srcs/docker-compose.yml

all: check-env up

check-env:
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "Error: $(ENV_FILE) not found!"; \
		echo "Please create $(ENV_FILE) from $(ENV_EXAMPLE)"; \
		echo "Run: cp $(ENV_EXAMPLE) $(ENV_FILE)"; \
		echo "Then edit $(ENV_FILE) with your configuration."; \
		exit 1; \
	fi

build: check-env
	@docker compose -f $(COMPOSE_FILE) build

up: check-env
	@mkdir -p $(DATA_PATH)/mysql $(DATA_PATH)/wordpress secrets/ssl
	@docker compose -f $(COMPOSE_FILE) up -d
	@echo "Access your site at: https://$(DOMAIN_NAME)"

start: check-env build up

down:
	@docker compose -f $(COMPOSE_FILE) down

clean:
	@docker compose -f $(COMPOSE_FILE) down -v

fclean: clean
	@docker compose -f $(COMPOSE_FILE) down -v --rmi all
	@rm -rf $(DATA_PATH)/mysql $(DATA_PATH)/wordpress secrets/ssl

re: fclean all

status:
	@docker compose -f $(COMPOSE_FILE) ps

logs:
	@docker compose -f $(COMPOSE_FILE) logs -f

restart: down up

.PHONY: all build up start down clean fclean re status logs restart check-env