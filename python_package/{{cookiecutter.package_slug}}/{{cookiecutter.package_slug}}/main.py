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
import logging
import sys
from os import path

from decouple import config
{% if cookiecutter.include_custom_utils == "yes" -%}
import logging.config
from .logger import get_logger
{%- endif -%}

SETTINGS = dict()
SENTRY_DSN = config('{{cookiecutter.package_slug.upper()}}_SENTRY_DSN', default=False)
here = path.abspath(path.dirname(__file__))
{% if cookiecutter.include_custom_utils == "yes" -%}
logger = get_logger('{{cookiecutter.package_slug}}')
{%- else -%}
logging.basicConfig(format='%(levelname)s - %(message)s', stream=sys.stdout, level=logging.DEBUG)
logger = logging.getLogger('{{cookiecutter.package_slug}}')
{%- endif %}

# Sentry integration
if (SENTRY_DSN):
    import sentry_sdk
    from sentry_sdk.integrations.logging import LoggingIntegration

    sentry_logging = LoggingIntegration(
        level=logging.WARNING,  # Capture warnings and above as breadcrumbs
        event_level=logging.ERROR
    )  # Send errors as events
    # if environment is staging or production, enable sentry
    sentry_sdk.init(dsn=SENTRY_DSN, integrations=[sentry_logging])


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
