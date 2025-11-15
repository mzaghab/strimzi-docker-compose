@Author: Mounir ZAGHAB

# Strimzi Docker Compose

A complete Kafka environment based on Strimzi, ready to use with Docker Compose. This project provides a full Kafka stack for local development, including Kafka, Schema Registry, Kafka Connect, and Kafka UI.

## 📋 Table of Contents

- [Overview](#overview)
- [Components](#components)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Services and Ports](#services-and-ports)
- [Configuration](#configuration)
- [Kafka Connect Plugins](#kafka-connect-plugins)
- [Useful Commands](#useful-commands)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

This project sets up a complete Kafka environment using:
- **Strimzi Kafka** : Kafka broker in KRaft mode (without Zookeeper)
- **Confluent Schema Registry** : Avro/JSON schema management
- **Strimzi Kafka Connect** : Framework to connect Kafka to other systems
- **Kafka UI** : Web interface to manage and visualize your Kafka cluster

## 🧩 Components

### Kafka (Strimzi)
- **Image** : `quay.io/strimzi/kafka:0.46.0-kafka-3.9.0`
- **Kafka Version** : 3.9.0
- **Mode** : KRaft (no Zookeeper)
- **Ports** :
  - `9092` : Internal communication between containers
  - `9094` : Access from host (localhost)
  - `9093` : KRaft controller port

### Schema Registry
- **Image** : `confluentinc/cp-schema-registry:7.5.3`
- **Port** : `8081`
- **Function** : Centralized data schema management

### Kafka Connect
- **Image** : `quay.io/strimzi/kafka:0.46.0-kafka-3.9.0`
- **Port** : `8083`
- **Function** : Connectors to integrate Kafka with other systems
- **Plugins** : Support for custom plugins via the `./kafka-plugins` volume

### Kafka UI
- **Image** : `provectuslabs/kafka-ui:latest`
- **Port** : `8082`
- **Function** : Web interface to visualize and manage the Kafka cluster

## 📦 Prerequisites

- **Docker** : Version 20.10 or higher
- **Docker Compose** : Version 2.0 or higher
- **Make** : Optional, to use Makefile commands

## 🚀 Installation

1. Clone this repository:
```bash
git clone <repo-url>
cd strimzi-docker-compose
```

2. Verify that Docker is running:
```bash
docker --version
docker compose version
```

## 💻 Usage

### Start all services

```bash
make up
# or
docker compose up -d
```

### Stop all services

```bash
make down
# or
docker compose down
```

### View logs

```bash
# All services
make logs

# Specific service
make logs SERVICE=kafka
```

### Check service status

```bash
make ps
# or
docker compose ps
```

### Access Kafka UI

Once services are started, open your browser at:
```
http://localhost:8082
```

## 🔌 Services and Ports

| Service | Port | Description |
|---------|------|-------------|
| Kafka (internal) | 9092 | Communication between containers |
| Kafka (external) | 9094 | Access from host (localhost:9094) |
| Kafka Controller | 9093 | KRaft controller port |
| Schema Registry | 8081 | REST API for schemas |
| Kafka Connect | 8083 | REST API for connectors |
| Kafka UI | 8082 | Web interface |

### Connecting to Kafka

**From host (your machine)**:
```bash
bootstrap.servers=localhost:9094
```

**From another Docker container**:
```bash
bootstrap.servers=kafka:9092
```

## ⚙️ Configuration

### Environment variables

Main configurations are defined in `docker-compose.yml`:

- **Kafka** : KRaft configuration with custom listeners
- **Schema Registry** : Connected to internal Kafka broker
- **Kafka Connect** : Uses JSON Converter with Schema Registry support
- **Kafka UI** : Configured to connect to all services

### Customization

To modify the configuration, edit the `docker-compose.yml` file. Main options:

- **Ports** : Modify port mappings according to your needs
- **Versions** : Change image tags to use other versions
- **Memory** : Add resource limits if necessary

## 🔌 Kafka Connect Plugins

The project includes a `kafka-plugins/` directory for custom plugins. The Confluent JDBC plugin is already included.

### Adding a plugin

1. Download the desired plugin
2. Place it in the `kafka-plugins/` directory
3. Restart the Kafka Connect service:
```bash
make restart
```

### Available plugins

- **JDBC Connector** : `confluentinc-kafka-connect-jdbc-10.9.0`
  - Support for PostgreSQL, MySQL, Oracle, SQL Server, SQLite

## 🛠️ Useful Commands

### Makefile

The project includes a Makefile with convenient commands:

```bash
make help          # Show help
make up            # Start all services
make down          # Stop and remove containers
make restart       # Restart all services
make logs          # Show logs (all or a service)
make ps            # List running containers
make stop          # Stop services without removing them
make clean         # Remove everything, including volumes
make run SERVICE=kafka  # Run a shell in a service
```

### Direct Docker Compose commands

```bash
# Create a topic
docker compose exec kafka /opt/kafka/bin/kafka-topics.sh \
  --create --topic test-topic --bootstrap-server localhost:9092 \
  --partitions 1 --replication-factor 1

# List topics
docker compose exec kafka /opt/kafka/bin/kafka-topics.sh \
  --list --bootstrap-server localhost:9092

# Consume messages
docker compose exec kafka /opt/kafka/bin/kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 --topic test-topic --from-beginning

# Produce messages
docker compose exec kafka /opt/kafka/bin/kafka-console-producer.sh \
  --bootstrap-server localhost:9092 --topic test-topic
```

## 🐛 Troubleshooting

### Services won't start

1. Check that ports are not already in use:
```bash
lsof -i :9092 -i :9094 -i :8081 -i :8082 -i :8083
```

2. Check logs:
```bash
make logs
```

3. Check available disk space:
```bash
df -h
```

### Kafka won't start

If Kafka fails to start, it may be due to:
- Ports already in use
- KRaft formatting issue (normal on first startup)
- Insufficient system resources

Solution: Remove volumes and restart:
```bash
make clean
make up
```

### Schema Registry can't connect to Kafka

Verify that Kafka is started before Schema Registry (dependency managed automatically). If the problem persists:

```bash
docker compose logs schema-registry
```

### Kafka Connect doesn't load plugins

Verify that the `kafka-plugins/` directory exists and contains plugins in the correct format. Plugins must be in subdirectories with their JAR structure.

## 📚 Resources

- [Strimzi Documentation](https://strimzi.io/documentation/)
- [Kafka Documentation](https://kafka.apache.org/documentation/)
- [Confluent Schema Registry Documentation](https://docs.confluent.io/platform/current/schema-registry/index.html)
- [Kafka Connect Documentation](https://kafka.apache.org/documentation/#connect)
- [Kafka UI Documentation](https://github.com/provectus/kafka-ui)

## 📝 Notes

- This project is designed for **local development** only
- Data is stored in Docker volumes (removed with `make clean`)
- For production, use appropriate configuration with security, replication, etc.
- KRaft mode eliminates the need for Zookeeper, simplifying the architecture

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or pull request.

