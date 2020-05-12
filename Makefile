UNAME := $(shell id -un)
UID := $(shell id -u)
GID := $(shell id -g)

all:
	docker build \
	    --build-arg "UNAME="$(UNAME) \
	    --build-arg "UID="$(UID) \
	    --build-arg "GID="$(GID) \
	    -t alanm0/writing-tools:latest .
