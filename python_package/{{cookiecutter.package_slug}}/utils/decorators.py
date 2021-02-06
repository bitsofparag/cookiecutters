"""Module providing decorator functions for debugging & development purposes."""
import functools
from os import environ
import time
from .logger import get_logger

ENVIRONMENT = environ.get('ENVIRONMENT')


def debug(func, *args, **kwargs):
    """Print the function signature and return value."""
    debug_logger = get_logger(ENVIRONMENT)

    @functools.wraps(func)
    def wrapper_debug(*args, logger=None, **kwargs):
        logger = logger or debug_logger
        args_repr = [repr(a) for a in args]
        kwargs_repr = [f"{k}={v!r}" for k, v in kwargs.items()]
        signature = ", ".join(args_repr + kwargs_repr)
        logger.debug("Calling %s(%s)", func.__name__, signature)
        value = func(*args, **kwargs)
        logger.debug("%s returned %s", func.__name__, value)
        return value
    return wrapper_debug


def timer(func, *args, **kwargs):
    """Print the runtime of the decorated function."""
    timer_logger = get_logger(ENVIRONMENT)

    @functools.wraps(func)
    def wrapper_timer(*args, logger=None, **kwargs):
        logger = logger or timer_logger
        start_time = time.perf_counter()
        value = func(*args, **kwargs)
        end_time = time.perf_counter()
        run_time = end_time - start_time
        logger.debug("Finished {:!r} in {:.4f}s".format(func.__name__, run_time))
        return value
    return wrapper_timer


def inspect_with(decorator, condition, *args, **kwargs):
    """Run the given `decorator` if `condition` is true."""
    def wrapper_inspect_with(function, *args, **kwargs):
        if condition(*args):
            return decorator(function, *args, **kwargs)
        else:
            return function
    return wrapper_inspect_with
