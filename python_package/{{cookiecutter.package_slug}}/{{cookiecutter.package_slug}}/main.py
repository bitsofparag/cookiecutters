"""This function does something cool.

Please update the doc for this module.
"""
from os import path, environ
import json
{%- if cookiecutter.include_custom_utils == "yes" %}
from .utils.logger import get_logger
{%- else %}
import logging
{%- endif %}

import sentry_sdk
from sentry_sdk.integrations.logging import LoggingIntegration

# enable settings and logging based on environment
ENVIRONMENT = environ.get('ENVIRONMENT', 'development')
SETTINGS = dict()
{%- if cookiecutter.include_custom_utils == "yes" %}
logger = get_logger(ENVIRONMENT)
{%- else %}
logger = logging.getLogger(ENVIRONMENT)
{% endif %}
logger.setLevel(logging.DEBUG)

# Sentry integration
if ((ENVIRONMENT == 'staging' or ENVIRONMENT == 'production')
        and environ.get('SENTRY_DSN')):
    sentry_logging = LoggingIntegration(
        level=logging.WARNING,      # Capture warnings and above as breadcrumbs
        event_level=logging.ERROR)  # Send errors as events
    # if environment is staging or production, enable sentry
    sentry_sdk.init(
        dsn=environ.get('SENTRY_DSN'),
        integrations=[sentry_logging],
        environment=ENVIRONMENT)


def main():
    """Run the main function that does something."""
    sample_data: dict = None

    if sample_data is None:
        here = path.abspath(path.dirname(__file__))
        with open(path.join(here, 'sample_data.json'), 'r') as json_file:
            sample_data = json.load(json_file)
    logger.debug(f"Do something with sample data {sample_data}")


if __name__ == '__main__':
    main()
