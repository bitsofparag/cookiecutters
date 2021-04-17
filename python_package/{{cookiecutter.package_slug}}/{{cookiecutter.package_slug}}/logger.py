#!/usr/bin/env python3
"""Logging module.

Provides a `get_logger` method that prepares the logger
from python's `logging` module based on a default config
(in `config/logging.json`) or a user-provided dict config
(which overrides the default config)

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
---
DEBUG, INFO, WARNING, ERROR and CRITICAL logs - all to console

testing
---
DEBUG, INFO, WARNING, ERROR and CRITICAL logs - all to console

staging
---
INFO, WARNING, ERROR and CRITICAL - rotating file handler called `staging.log`

production
---
ERROR and CRITICAL logs - Sentry as well as a rotating file handler called `production.log`
"""
import json
import logging
import logging.config
import platform
from os import path

from decouple import config


SENTRY_DSN = config('SENTRY_DSN', default=False)
HOSTNAME = platform.node()


class HostnameFilter(logging.Filter):
    """Creates a filter for hostname in logging records."""

    hostname = platform.node()

    def filter(self, record):
        """Add hostname to a logging `record` object."""
        record.hostname = HostnameFilter.hostname
        return True


def get_logger(name):
    """Get the logger for the module."""
    here = path.abspath(path.dirname(__file__))
    with open(path.join(here, 'config/logging.json'), 'r') as json_file:
        config = json.load(json_file)
        if SENTRY_DSN:
            config["loggers"]["staging"]["handlers"].append("sentry")
            config["loggers"]["production"]["handlers"].append("sentry")
        logging.config.dictConfig(config)
    return logging.getLogger(name or __file__)
