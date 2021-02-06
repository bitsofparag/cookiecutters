.PHONY: build clean clean-test clean-pyc clean-build lint docs help
.DEFAULT_GOAL := help
SHELL=/bin/bash

ENVIRONMENT ?=

ifeq ($(ENVIRONMENT), )
ENVIRONMENT := development
include .env
export
endif

ifeq ($(ENVIRONMENT), $(filter $(ENVIRONMENT), staging production))
include .env.production
export
endif

define BROWSER_PYSCRIPT
import os, webbrowser, sys
from urllib.request import pathname2url
webbrowser.get('firefox').open_new_tab("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT

define PRINT_HELP_PYSCRIPT
import re, sys
for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

SRC=.  # Update with correct path of src files
BROWSER := python -c "$$BROWSER_PYSCRIPT"
PACKAGE_VERSION ?= 0.1-$(ENVIRONMENT)
PYTHON_VERSION ?= {{cookiecutter.python_version}}
PAYLOAD_NAME := payload-$(PACKAGE_VERSION).zip
TMP_VENV := tmp-venv
PROJECT_ROOT := $(PWD)

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

clean: clean-build clean-pyc clean-test ## remove all build, test, coverage and Python artifacts

clean-build: ## remove build artifacts
	rm -fr .eggs/
	find . -name 'dist' -exec rm -rf {} + 2>/dev/null
	find . -name 'build' -exec rm -rf {} + 2>/dev/null
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc: ## remove Python file artifacts and logs
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +
	find . -name '*.log*' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache

lint: ## check style with flake8
	flake8 $(SRC) tests

docs: ## generate Sphinx HTML documentation
	$(MAKE) -C docs clean
	$(MAKE) -C docs html
	$(BROWSER) docs/build/html/index.html

_venv:
	@python -m venv ./$(TMP_VENV)

build-deps: requirements.txt
ifeq ("$(wildcard setup.py)","")
	@python -m venv ./$(TMP_VENV)
	@echo "Compiling and packaging dependencies"
	@bash -c "source $(TMP_VENV)/bin/activate \
	&& pip install -r requirements.txt \
	&& cd $(TMP_VENV)/lib/python$(PYTHON_VERSION)/site-packages/ \
	&& zip -r9 $(PROJECT_ROOT)/dist/$(PAYLOAD_NAME) ."
else
	@python -m venv ./$(TMP_VENV)
	@echo "Dependencies will be compiled in build task."
endif

build: clean build-deps ## builds src files for distribution
ifeq ("$(wildcard setup.py)","")
	bash -c "source $(TMP_VENV)/bin/activate \
	&& python3 -m compileall $(SRC) -x $(TMP_VENV) \
	&& zip -rg dist/$(PAYLOAD_NAME) handler.py config utils \
	&& deactivate"
else
	@python setup.py sdist
	@python setup.py bdist_wheel
	@ls -l dist
endif
	@rm -rf $(TMP_VENV)

# https://github.com/horejsek/python-webapp-example/blob/master/Makefile
# https://github.com/audreyr/cookiecutter-pypackage/blob/master/%7B%7Bcookiecutter.project_slug%7D%7D/Makefile
