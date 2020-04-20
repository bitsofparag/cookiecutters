# -*- encoding: utf-8 -*-
# {{ cookiecutter.package_name }} v{{ cookiecutter.package_version }}
# {{ cookiecutter.package_description }}
#
"""
{{ cookiecutter.package_description }}
:Copyright: © {% now 'utc', '%Y' -%}, {{ cookiecutter.author_name }}.
:License: {% now 'utc', '%Y' -%} (see /LICENSE).
"""

__title__ = '{{ cookiecutter.package_name }}'
__version__ = '{{ cookiecutter.package_version }}'
__author__ = '{{ cookiecutter.author_name }}'
__license__ = '{{ cookiecutter.license }}'

# __all__ affects the from <module> import * behavior only.
__all__ = ()
