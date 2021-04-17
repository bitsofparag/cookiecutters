# {{cookiecutter.package_name}}
======================

{{cookiecutter.package_description}}

* Git repo: https://{{cookiecutter.git_provider}}.com/{{cookiecutter.git_user_or_group_name}}/{{cookiecutter.package_slug}}
* Documentation: https://{{cookiecutter.git_provider}}.com/{{cookiecutter.git_user_or_group_name}}/{{cookiecutter.package_slug}}/docs
* Free software: {{cookiecutter.license}}

# Features
--------

# Setup and Usage
---------------

1. `pip install -r requirements.txt -r requirements-dev.txt`

2. `python -m {{cookiecutter.package_slug}}.main`

{% if cookiecutter.build_script == "Makefile" -%}
Run `make` for more commands
{%- endif -%}


# Build Status
------------


# Contributing Guidelines
-----------------------
