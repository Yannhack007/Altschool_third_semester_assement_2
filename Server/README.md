# MuchToDo API

A robust RESTful API for a ToDo application built with Go (Golang). This project features user authentication, JWT-based session management, CRUD operations for ToDo items, and an optional Redis caching layer.

The API is built with a clean, layered architecture to separate concerns, making it scalable and easy to maintain. It includes a full suite of unit and integration tests and provides interactive API documentation via Swagger.

## Features

* **User Management**: Secure user registration, login, update, and deletion.
* **Authentication**: JWT-based authentication that supports both `httpOnly` cookies (for web clients) and `Authorization` headers.
* **CRUD for ToDos**: Full create, read, update, and delete functionality for user-specific ToDo items.
* **Structured Logging**: Configurable, structured JSON logging with request context for production-ready monitoring.
* **Optional Caching**: Redis-backed caching layer that can be toggled on or off via environment variables.
* **API Documentation**: Auto-generated interactive Swagger documentation.
* **Testing**: Comprehensive unit and integration test suites.
* **Graceful Shutdown**: The server shuts down gracefully, allowing active requests to complete.

## Prerequisites

To run this project locally, you will need the following installed:

* **Go**: Version 1.21 or later.
* **Swag CLI**: To generate the Swagger API documentation.
* **Make** (optional, for easier command execution):

  On macOS, you can install `make` via Homebrew if it's not already available:

  ```bash
  brew install make
  ```

  On Linux, `make` is usually pre-installed or available via your package manager.

```bash
go install github.com/swaggo/swag/cmd/swag@latest
```

## Using Make

This project includes a `Makefile` to simplify common development tasks. You can use `make <target>` to run commands such as starting the server, building, running tests, and managing Docker containers.

## Getting Started

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd much-to-do/Server/MuchToDo
```

### 2. Configure Environment Variables

Create a `.env` file in the root of the project by copying the example.

```bash
cp .env.example .env
```

Now, open the `.env` file and **change the** `JWT_SECRET_KEY` to a new, long, random string.

Also, ensure that the `MONGO_URI` and `DB_NAME` points to your local MongoDB instance and db.

You can leave the other variables as they are for local development.

### 3. Start Local Dependencies

With Docker running, start the MongoDB and Redis containers using Docker Compose.

```bash
docker-compose up -d
```
**Or using Make:**
```bash
make dc-up
```

### 4. Install Go Dependencies

Download the necessary Go modules.

```bash
go mod tidy
```
**Or using Make:**
```bash
make tidy
```

### 5. Generate API Documentation

Generate the Swagger/OpenAPI documentation from the code comments.

```bash
swag init -g cmd/api/main.go
```
**Or using Make:**
```bash
make generate-docs
```

### 6. Run the Application

You can now run the API server.

```bash
go run ./cmd/api/main.go
```
**Or using Make (also generates docs first):**
```bash
make run
```

The server will start, and you should see log output in your terminal.

* The API will be available at `http://localhost:3000`.
* The interactive Swagger documentation will be at `http://localhost:3000/swagger/index.html`.

## Running Tests

The project includes both unit and integration tests.

### Run Unit Tests

These tests are fast and do not require any external dependencies.

```bash
go test ./...
```
**Or using Make:**
```bash
make unit-test
```

### Run Integration Tests

These tests require Docker to be running as they spin up their own temporary database and cache containers.

```bash
INTEGRATION=true go test -v --tags=integration ./...
```
**Or using Make:**
```bash
make integration-test
```

The `INTEGRATION=true` environment variable is required to explicitly enable these tests. The `-v` flag provides verbose output.

## Other Useful Make Commands

- **Build the binary:**  
  ```bash
  make build
  ```
- **Clean build artifacts:**  
  ```bash
  make clean
  ```
- **Stop Docker containers:**  
  ```bash
  make dc-down
  ```
- **Restart Docker containers:**  
  ```bash
  make dc-restart
  ```

Refer to the `Makefile` for more available commands.

---

# MuchTodo Backend Containerization & Kubernetes Deployment

This repository contains the Docker and Kubernetes setup for the MuchTodo backend API. It allows you to run the application locally with Docker Compose or deploy it to a local Kubernetes cluster using Kind.

## Table of Contents

- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Docker Setup](#docker-setup)
- [Build the Docker Image](#build-the-docker-image)
- [Run Docker Compose](#run-docker-compose)
- [Verify Containers](#verify-containers)
- [Kubernetes Deployment](#kubernetes-deployment)
- [Create Namespace](#create-namespace)
- [Deploy MongoDB](#deploy-mongodb)
- [Deploy Backend API](#deploy-backend-api)
- [Verify Pods & Services](#verify-pods--services)
- [Testing the API](#testing-the-api)
- [Cleanup](#cleanup)

## Project Structure

```
container-assessment/
├── Server/MuchToDo/              # Backend API source code
├── Dockerfile                    # Multi-stage Dockerfile for backend
├── docker-compose.yml            # Local development setup
├── .dockerignore                 # Files to ignore in Docker builds
├── kubernetes/
│   ├── namespace.yaml
│   ├── mongodb/
│   │   ├── mongodb-secret.yaml
│   │   ├── mongodb-configmap.yaml
│   │   ├── mongodb-pvc.yaml
│   │   ├── mongodb-deployment.yaml
│   │   └── mongodb-service.yaml
│   ├── backend/
│   │   ├── backend-secret.yaml
│   │   ├── backend-configmap.yaml
│   │   ├── backend-deployment.yaml
│   │   └── backend-service.yaml
│   └── ingress.yaml              # (Optional)
├── scripts/
│   ├── docker-build.sh
│   ├── docker-run.sh
│   ├── k8s-deploy.sh
│   └── k8s-cleanup.sh
└── README.md
```

## Prerequisites

- Docker Desktop
- kubectl
- Kind
- Bash shell (for scripts)

## Docker Setup

### Build the Docker Image

```bash
cd container-assessment
./scripts/docker-build.sh
```

Builds the backend API image `much-to-do-api:latest` using the Dockerfile.

### Run Docker Compose

```bash
./scripts/docker-run.sh
```

Starts all required containers:

- much-to-do-api (backend)
- mongodb
- redis

Uses persistent volumes for MongoDB and Redis.

### Verify Containers

```bash
docker compose ps
docker logs much-to-do-api
curl http://localhost:3000/health
```

The `/health` endpoint should return a 200 OK response.

## Kubernetes Deployment

### Create Namespace

```bash
kubectl apply -f kubernetes/namespace.yaml
```

### Deploy MongoDB

```bash
kubectl apply -f kubernetes/mongodb/
```

Creates:

- Deployment with 1 replica
- PersistentVolumeClaim for data storage
- Secret for credentials
- Service for internal communication

### Deploy Backend API

```bash
kubectl apply -f kubernetes/backend/
```

Creates:

- Deployment with 2 replicas
- ConfigMap and Secret for environment variables
- Service for internal access

### Verify Pods & Services

```bash
kubectl get pods -n muchtodo
kubectl get svc -n muchtodo
```

Ensure all pods are Running and services have ClusterIP assigned.

## Testing the API

You can test the backend API directly using the ClusterIP:

```bash
kubectl port-forward svc/backend 3000:3000 -n muchtodo
curl http://localhost:3000/health
```

Or use Docker Compose setup (`http://localhost:3000/health`).

## Cleanup

### Remove Kubernetes Resources

```bash
./scripts/k8s-cleanup.sh
```

### Stop Docker Compose

```bash
docker compose down -v
```

`-v` removes associated volumes for a clean start.

This setup ensures the MuchTodo backend can run locally with Docker or on a Kind Kubernetes cluster with persistence and proper configuration.