#!/usr/bin/env python3
"""Logging module.

Provides a `get_logger` method that prepares a `logger` instance
from python's `logging` module based on a default dict config
(in `config/logging.json`) or, perhaps, a user-provided dict_config (which overrides the default config), like so:

    from .logger import get_logger

    log = get_logger("my_logger", dict_config="../../log.json")
    log.debug("I am a breakpoint {}".format(num))

Please edit the logging json file for configuring the logger for the package

If you **don't use** the `config/logging.json` file, then the `get_logger` invocation returns the python logger with a simple formatter and a streamhandler with log level set to INFO

    from .logger import get_logger

    log = get_logger("my_logger")
    log.info("I am a log message {}".format(num))

---

To enable file handlers for staging and production, you can
add the following to the "handlers" section:

```
"staging_file_handler": {
  "class": "logging.handlers.RotatingFileHandler",
  "level": "INFO",
  "formatter": "simple",
  "filters": ["add_hostname"],
  "filename": "staging.log",
  "maxBytes": 10485760,
  "backupCount": 20,
  "encoding": "utf8"
},

"production_file_handler": {
  "class": "logging.handlers.RotatingFileHandler",
  "level": "ERROR",
  "formatter": "simple",
  "filters": ["add_hostname"],
  "filename": "production.log",
  "maxBytes": 10485760,
  "backupCount": 20,
  "encoding": "utf8"
}
```

----

If you host the app in AWS with the above handlers, you'll need a bridge
from your app to Cloudwatch logs. We use
[Watchtower](https://github.com/kislyuk/watchtower) as the bridge:
```
"aws_cloudwatch_handler": {
  "level": "INFO",
  "class": "watchtower.CloudWatchLogHandler",
  "filters": ["add_hostname"],
  "boto3_session":"boto3_session",
  "formatter": "simple"
}
```
Add `watchtower` in your `requirements.txt` file.

----

For colored output in console, the `colorlog` package is used.
See [the documentation here](https://github.com/revolunet/colorlog).
You can configure the colors in `config/logging.json` file.

```
fg_{colorname}, bg_{colorname}: Foreground and background colors.The colors names are:
black, red,green, yellow, blue, purple, cyan and white.
bold: Bold output.
```

The default config sets the following logging options based on the `ENVIRONMENT` variable:

development
DEBUG, INFO, WARNING, ERROR and CRITICAL logs - all to console

testing
---
DEBUG, INFO, WARNING, ERROR and CRITICAL logs - all to console

staging
---
INFO, WARNING, ERROR and CRITICAL logs

production
---
ERROR and CRITICAL logs

Hostname filter
---
By GDPR regulations, IP addresses are considered personal data, generally speaking.
If you wish to log IP address and have legal consent to do so, please attach the
following hostname capture filter:

    class HostnameFilter(logging.Filter):
        hostname = platform.node()

        def filter(self, record):
            record.hostname = HostnameFilter.hostname
            return True

And in the logging.json (or logging dict config), add the following:

    "filters": {
      ...
      "add_hostname": {
        "()": "utils.logger.HostnameFilter"
      }
    },
    "formatters": {
      "simple": {
        "format": "[%(levelname)s][%(asctime)s] - %(hostname)s - %(message)s"
      }
    },
    "handlers": {
      "console": {
        ...
        "formatter": "simple",
        "filters": ["add_hostname"],
        ...
      }
    },
    ...
---
"""
from os import environ, path
import json
import platform
import logging
import logging.config


ENVIRONMENT = environ.get('ENVIRONMENT', 'development')
SENTRY_DSN = environ.get('SENTRY_DSN')
HOSTNAME = platform.node()


def _get_simple_logger(name):
    print('Setting my simple logger.')
    log = logging.getLogger(name or ENVIRONMENT)
    log.setLevel(logging.INFO)
    streamHandler = logging.StreamHandler()
    formatter = logging.Formatter("[%(levelname)s]%(asctime)s : %(message)s")
    streamHandler.setFormatter(formatter)
    log.addHandler(streamHandler)
    return log


def get_logger(name, dict_config='../config/logging.json'):
    """Get the logger for the module."""
    here = path.abspath(path.dirname(__file__))
    logging_json = path.join(here, dict_config)
    logger = None
    if path.exists(logging_json):
        try:
            with open(logging_json, 'r') as json_file:
                config = json.load(json_file)
                if SENTRY_DSN:
                    config["loggers"]["staging"]["handlers"].append("sentry")
                    config["loggers"]["production"]["handlers"].append("sentry")
                logging.config.dictConfig(config)
                logger = logging.getLogger(name or ENVIRONMENT)
        except json.JSONDecodeError as e:
            print('Error reading json: ', e.message)
            raise e
        return logger

    return _get_simple_logger(name)
