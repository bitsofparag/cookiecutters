#!/usr/bin/env python
# -*- encoding: utf-8 -*-
# {{ cookiecutter.package_name }} test suite
# Copyright © {% now 'utc', '%Y' -%}, {{ cookiecutter.author_name }}.
# See /LICENSE for licensing information.
import {{ cookiecutter.package_slug }}


def test_true():
    """Test if True is truthy."""
    assert True
