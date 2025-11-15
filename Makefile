.PHONY: help up down run restart logs ps stop clean

# Default target
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@echo "  up        - Start all services in detached mode"
	@echo "  down      - Stop and remove all containers, networks"
	@echo "  run       - Run a one-off command in a service (usage: make run SERVICE=service-name)"
	@echo "  restart   - Restart all services"
	@echo "  logs      - Show logs from all services (usage: make logs SERVICE=service-name for specific service)"
	@echo "  ps        - List running containers"
	@echo "  stop      - Stop all services without removing containers"
	@echo "  clean     - Stop and remove containers, networks, and volumes"
	@echo "  help      - Show this help message"

# Start all services
up:
	docker compose up -d

# Stop and remove all containers
down:
	docker compose down

# Run a command in a service
run:
	@if [ -z "$(SERVICE)" ]; then \
		echo "Error: SERVICE is required. Usage: make run SERVICE=service-name "; \
		exit 1; \
	fi
	docker compose run --rm $(SERVICE) bash

# Restart all services
restart:
	docker compose restart

# Show logs
logs:
	@if [ -z "$(SERVICE)" ]; then \
		docker compose logs -f; \
	else \
		docker compose logs -f $(SERVICE); \
	fi

# List running containers
ps:
	docker compose ps

# Stop all services
stop:
	docker compose stop

# Clean everything including volumes
clean:
	docker compose down -v

