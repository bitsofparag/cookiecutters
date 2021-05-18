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

1. `cp .env.example .env`

2. `pip install -r requirements.txt -r requirements-dev.txt`

3. `python -m {{cookiecutter.package_slug}}.main`

{% if cookiecutter.build_script == "Makefile" -%}
Run `make` for more commands
{%- endif %}


# Build
-------

1. Run `make build`

2. The package will be available in the `dist` folder. You can publish it to a package registry or
   containerize it.

3. If the `cli` option is configured in `setup.py`, then to test the build locally:

  - `pip install dist/{{cookiecutter.package_slug}}-{{cookiecutter.package_version}}-py3-none-any.whl`

  - `{{cookiecutter.package_slug}}`


# Contributing Guidelines
-----------------------
