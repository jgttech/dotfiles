IMAGE_NAME := dotfiles
IMAGE_ID := $(shell podman images | grep $(IMAGE_NAME) | awk '{ print $$3 }' | grep -v '^$$')
CONTAINER_ID := $(shell podman ps -a | grep $(IMAGE_NAME) | awk '{ print $$1 }' | grep -v '^$$')

.PHONY: build
build: rmi
	@echo "Building new image: $(IMAGE_NAME)"
	@podman build --file=Containerfile.archlinux -t $(IMAGE_NAME) --format=docker .

.PHONY: rmi
rmi:
	@if [ -n "$(IMAGE_ID)" ]; then \
		echo "Removing image with ID: $(IMAGE_ID)"; \
		podman rmi $(IMAGE_ID) -f; \
	else \
		echo "No image found to remove"; \
	fi

.PHONY: rm
rm:
	@if [ -n "$(CONTAINER_ID)" ]; then \
		echo "Removing container with ID: $(CONTAINER_ID)"; \
		podman kill $(CONTAINER_ID) &> /dev/null; \
		podman rm -f $(CONTAINER_ID) &> /dev/null; \
	else \
		echo "No container found to remove"; \
	fi

.PHONY: list
list:
	@echo -e "\n[CONTAINERS]"; \
	podman ps -a

	@echo -e "\n[IMAGES]"; \
	podman images

	@echo -e "\n[NETWORKS]"; \
	podman network ls

	@echo -e "\n[VOLUMES]"; \
	podman volume ls

.PHONY: clean
clean: rm rmi list

.PHONY: ssh
ssh:
	@if [ -z "$(IMAGE_ID)" ]; then \
		make build; \
	fi

	@if [ -z "$(CONTAINER_ID)" ]; then \
		echo "Attaching to container..."; \
		podman run -it $(IMAGE_NAME) /bin/zsh; \
	else \
		echo "Starting and attaching to container..."; \
		podman start $(CONTAINER_ID) &> /dev/null; \
		podman exec -it $(CONTAINER_ID) /bin/zsh; \
	fi

.PHONY: version
version: rm build
	@podman run -it $(IMAGE_NAME) /bin/zsh -c "cat .dotfiles/dotfiles.json | jq '.version' | tr -d '\"'; exec /bin/zsh"

.PHONY: install
install: rm build
	@podman run -it $(IMAGE_NAME) /bin/zsh -c "cat .dotfiles/bin/install | python - -D; exec /bin/zsh"

.PHONY: prod
prod: rm build
	@podman run -it $(IMAGE_NAME) /bin/zsh -c "cat .dotfiles/bin/install | python; exec /bin/zsh"
