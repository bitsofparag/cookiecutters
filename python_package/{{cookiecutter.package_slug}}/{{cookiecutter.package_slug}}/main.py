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
{% if cookiecutter.include_custom_utils == "yes" -%}
import logging.config
from .logger import get_logger
{% endif -%}


ENVIRONMENT = environ.get('ENVIRONMENT', 'development')
SETTINGS = dict()
{% if cookiecutter.include_custom_utils == "yes" %}
logger = get_logger(ENVIRONMENT)
{% else %}
logger = logging.getLogger(ENVIRONMENT)
logger.setLevel(logging.DEBUG)
{% endif %}

{% if cookiecutter.sentry_dsn != "" %}
# Sentry integration
if (
    (ENVIRONMENT == 'staging' or ENVIRONMENT == 'production')
    and environ.get('SENTRY_DSN')
):
    sentry_logging = LoggingIntegration(
        level=logging.WARNING,  # Capture warnings and above as breadcrumbs
        event_level=logging.ERROR
    )  # Send errors as events
    # if environment is staging or production, enable sentry
    sentry_sdk.init(
        dsn=environ.get('SENTRY_DSN'),
        integrations=[sentry_logging],
        environment=ENVIRONMENT
    )
{% endif %}

def main(*args, **kwargs):
    """Print hello world.

    :some_arg type: describe the argument `some_arg`
    """
    logger.debug('Hello world!')
    logger.debug('This is {{cookiecutter.package_name}}.')
    logger.debug('You should customize this file or delete it.')
    logger.debug('--------------------------------------------')
{% if cookiecutter.include_custom_utils == "yes" %}
    logger.debug('If you see this, the custom logger is configured.')
{% else %}
    logger.debug('Please configure your own logger with logging.config,')
    logger.debug('for e.g, read logging config from "config/logging.json" file.')
{% endif %}

if __name__ == '__main__':
    main()
