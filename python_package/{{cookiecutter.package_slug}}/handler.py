"""This function transforms data in an AWS event.

Please update the doc for this handler.
"""
from os import path
import logging
{%- if cookiecutter.include_custom_utils == "yes" %}
import logging.config
from utils.logger import get_logger
{% endif -%}

import sentry_sdk
from sentry_sdk.integrations.logging import LoggingIntegration
{%- if cookiecutter.is_aws_lambda %}
from sentry_sdk.integrations.aws_lambda import AwsLambdaIntegration
{% endif %}


# enable settings and logging based on environment
SETTINGS = dict()
SENTRY_DSN = config('{{cookiecutter.package_slug.upper()}}_SENTRY_DSN', default=False)
{%- if cookiecutter.include_custom_utils == "yes" %}
logger = get_logger('{{cookiecutter.package_slug}}')
{%- else %}
logger = logging.getLogger('{{cookiecutter.package_slug}}')
{%- endif %}
logger.setLevel(logging.DEBUG)

# Sentry integration
if (SENTRY_DSN):
    sentry_logging = LoggingIntegration(
        level=logging.WARNING,      # Capture warnings and above as breadcrumbs
        event_level=logging.ERROR)  # Send errors as events
    {% if cookiecutter.is_aws_lambda %}
    aws_lambda_logging = AwsLambdaIntegration(timeout_warning=True)
    {% endif -%}
    sentry_sdk.init(
        dsn=SENTRY_DSN,
        integrations=[sentry_logging, {% if cookiecutter.is_aws_lambda %}aws_lambda_logging{% endif %}],
    )

__required_keys = ['records']


def __transform(data):
    logger.debug(f"Transforming data {data}")
    return data


def handle(event, context):
    """Run the transform operation on a property of the AWS event.

    Add this to the Terraform function name as "handler.handle".
    """
    if (
            not isinstance(event, dict)
            or not all(key in event for key in __required_keys)
    ):
        message = "Bad request, maybe check the AWS Lambda docs for the service?"
        logger.error(message)
        return event

    logger.debug(f"Receiving event: {event}")
    result = __transform(event.get('<pick a key from required keys>'))
    logger.debug("Returning result: %s", result)
    return result


def main(sample_event=None, context=None):
    """Run in development mode. This is ignored in AWS Lambda."""
    if sample_event is None:
        here = path.abspath(path.dirname(__file__))
        with open(path.join(here, 'sample_data.json'), 'r') as json_file:
            sample_event = json.load(json_file)
    handle(sample_event, context)


if __name__ == '__main__':
    main()
