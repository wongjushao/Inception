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

check-hosts:
	@if ! grep -q "$(DOMAIN_NAME)" /etc/hosts 2>/dev/null; then \
		echo "Warning: $(DOMAIN_NAME) not found in /etc/hosts"; \
		echo "Your browser won't be able to resolve the domain."; \
		echo ""; \
		echo "To fix this, add the following line to /etc/hosts:"; \
		echo "  127.0.0.1    $(DOMAIN_NAME)"; \
		echo ""; \
		echo "Run this command (requires sudo):"; \
		echo "  sudo sh -c 'echo \"127.0.0.1    $(DOMAIN_NAME)\" >> /etc/hosts'"; \
		echo ""; \
	fi

build: check-env
	@docker compose -f $(COMPOSE_FILE) build

up: check-env
	@mkdir -p $(DATA_PATH)/mysql $(DATA_PATH)/wordpress secrets/ssl
	@docker compose -f $(COMPOSE_FILE) up -d
	@$(MAKE) check-hosts
	@echo ""
	@echo "✓ Inception is running!"
	@echo "Access your site at: https://$(DOMAIN_NAME)"

start: build up

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

.PHONY: all build up start down clean fclean re status logs restart check-env check-hosts