"""
{{cookiecutter.package_name}}.
~~~~~~~~~~~~~~~~~~~~~

{{cookiecutter.package_description}}

Basic usage:
    >>> import {{cookiecutter.package_slug}}
    >>> {{cookiecutter.package_slug}}()

:copyright: (c) {% now 'utc', '%Y' %} {{cookiecutter.author_name}}.
:license: {{cookiecutter.license}}, see LICENSE for more details.
"""
from os import environ, path
import logging
import logging.config
{% if cookiecutter.include_custom_logger == "yes" -%}
from .logger import get_logger
{% endif -%}


ENVIRONMENT = environ.get('ENVIRONMENT', 'development')
SETTINGS = dict()


def main(*args, **kwargs):
    """Print hello world.

    :some_arg type: describe the argument `some_arg`
    """
{% if cookiecutter.include_custom_logger == "yes" %}
    logger = get_logger(ENVIRONMENT)
{% endif %}
    print('Hello world!')
    print('This is {{cookiecutter.package_name}}.')
    print('You should customize this file or delete it.')
    print('--------------------------------------------')
{% if cookiecutter.include_custom_logger == "yes" %}
    logger.debug('If you see this, the custom logger is configured.')
{% else %}
    print('Please configure your own logger with logging.config,')
    print('for e.g, read logging config from "config/logging.json" file.')
{% endif %}

if __name__ == '__main__':
    main()
