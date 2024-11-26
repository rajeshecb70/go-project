# Load environment variables from .env file if it exists
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Variables
DOCKER_USER = rajeshecb70
DOCKER_IMAGE = goproject
TAG = 1.1.0

# Check the Go version
version:
	@echo "Check the go version..."
	go version

# Install dependencies
install:
	@echo "Install the dependencies..."
	go mod download

# Run linting
lint:
	@echo "Check the linting..."
	golangci-lint run main.go main_test.go

# Run tests
test:
	@echo "Test the project..."
	go test -v

# Build and tag the Docker image
docker-build:
	@echo "Building Docker image..."
	docker build -t $(DOCKER_IMAGE):$(TAG) .
	@echo "Tagging Docker image..."
	docker tag $(DOCKER_IMAGE):$(TAG) $(DOCKER_USER)/$(DOCKER_IMAGE):$(TAG)


# Login to Docker Hub
docker-login:
	@echo "Logging in to Docker Hub..."
	@docker login -u $(DOCKER_USERNAME) -p $(DOCKER_PASSWORD)

# Push the Docker image to Docker Hub
docker-push: docker-login
	@echo "Pushing Docker image to Docker Hub..."
	docker push $(DOCKER_USER)/$(DOCKER_IMAGE):$(TAG)

# Run the Docker container locally
docker-run:
	@echo "Running Docker container locally..."
	docker run -d -p 8080:8080 --name $(DOCKER_IMAGE) $(DOCKER_USER)/$(DOCKER_IMAGE):$(TAG)