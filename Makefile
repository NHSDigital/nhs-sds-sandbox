SHELL:=/bin/bash -O globstar
.SHELLFLAGS = -ec
.PHONY: build dist
.DEFAULT_GOAL := list
# this is just to try and supress errors caused by poetry run
export PYTHONWARNINGS=ignore:::setuptools.command.install

list:
	@grep '^[^#[:space:]].*:' Makefile

guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

########################################################################################################################
##
## Makefile for this project things
##
########################################################################################################################
pwd := ${PWD}
dirname := $(notdir $(patsubst %/,%,$(CURDIR)))
DOCKER_BUILDKIT ?= 1

ifneq (,$(wildcard ./.env))
    include .env
    export
endif


BUILDKIT_ARGS := COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=$(DOCKER_BUILDKIT) BUILDKIT_PROGRESS=plain

delete-hooks:
	rm .git/hooks/pre-commit 2>/dev/null || true

.git/hooks/pre-commit:
	cp scripts/hooks/pre-commit.sh .git/hooks/pre-commit

refresh-hooks: delete-hooks .git/hooks/pre-commit

docker-build:
	$(BUILDKIT_ARGS) docker compose build --build-arg BUILDKIT_INLINE_CACHE=1

down:
	$(BUILDKIT_ARGS) docker compose down --remove-orphans || true

up:
	$(BUILDKIT_ARGS) docker compose  up -d --remove-orphans --build


install:
	poetry install --sync

install-ci:
	poetry install --without local --sync

black-check:
	poetry run black . --check

black:
	poetry run black .

mypy:
	poetry run mypy . --exclude '(^|/)(deps|build|dist|scripts)/.*\.py'

ruff: black
	poetry run ruff --fix --show-fixes .

ruff-check:
	poetry run ruff .

ruff-ci:
	poetry run ruff --format=github .

shellcheck:
	@# Only swallow checking errors (rc=1), not fatal problems (rc=2)
	docker run --rm -i -v ${PWD}:/mnt:ro koalaman/shellcheck -f gcc -e SC1090,SC1091 `find . \( -path "*/.venv/*" -prune -o -path "*/build/*" -prune -o -path "*/.tox/*" -prune \) -o -type f -name '*.sh' -print` || test $$? -eq 1

hadolint:
	docker run --rm -i hadolint/hadolint < Dockerfile

lint: ruff mypy shellcheck hadolint
pylint: ruff mypy

check-secrets:
	scripts/check-secrets.sh

check-secrets-all:
	scripts/check-secrets.sh unstaged

test:
	poetry run pytest