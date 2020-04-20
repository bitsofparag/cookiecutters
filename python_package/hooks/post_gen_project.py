import os
from os.path import join


def unlink_if_exists(path):
    if os.path.exists(path):
        os.unlink(path)

if __name__ == "__main__":
    has_custom_logger = "{{cookiecutter.include_custom_logger}}"

    if has_custom_logger == "no":
        unlink_if_exists(join('{{ cookiecutter.package_slug }}', 'config/logging.json'))

    print("""
################################################################################
################################################################################
    You have succesfully created `{{ cookiecutter.package_name }}`.
################################################################################
    You've used these cookiecutter parameters:
{% for key, value in cookiecutter.items()|sort %}
        {{ "{0:26}".format(key + ":") }} {{ "{0!r}".format(value).strip("u") }}
{%- endfor %}
################################################################################
    """)
