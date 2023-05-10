# flake8: noqa
"""Setuptools package file for {{cookiecutter.package_name}}."""
import io
from os import environ, path

from setuptools import find_packages, setup

AUTHOR = environ.get('AUTHOR', '{{cookiecutter.author_name}}')
AUTHOR_EMAIL = environ.get('AUTHOR_EMAIL', '{{cookiecutter.author_email}}')
PACKAGE_VERSION = environ.get('PACKAGE_VERSION', '0.1.0')

here = path.abspath(path.dirname(__file__))
readme = io.open(path.join(here, 'README.md'), 'r', encoding='utf-8').read()
requirements = io.open(path.join(here, 'requirements.txt'), 'r').read().splitlines()


setup(
    name='{{cookiecutter.package_slug}}',
    version=PACKAGE_VERSION,
    author=AUTHOR,
    author_email=AUTHOR_EMAIL,
    maintainer=AUTHOR,
    maintainer_email=AUTHOR_EMAIL,
    license='{{cookiecutter.license}}',
    description='''
    {{cookiecutter.package_description}}
    ''',
    long_description=readme,
    url='https://{{cookiecutter.git_provider}}.com/{{cookiecutter.git_user_or_group_name}}/{{cookiecutter.package_slug.replace('_', '-')}}.git',
    packages=find_packages(exclude=['test*']),
    python_requires='!=2.*, >3.0, >={{cookiecutter.python_version}}',
    setup_requires=['wheel'],
    include_package_data=True,
    zip_safe=False,
    install_requires=requirements,
    classifiers=[
        'Development Status :: 1 - Planning',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: {{cookiecutter.python_version}}',
        'Operating System :: OS Independent',
{%- if cookiecutter.license == "MIT" %}
        'License :: OSI Approved :: MIT License',
{%- elif cookiecutter.license == "BSD-3" %}
        'License :: OSI Approved :: BSD License',
{%- elif cookiecutter.license == "GNU GPL v3.0" %}
        'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
{%- elif cookiecutter.license == "Apache 2.0" %}
        'License :: OSI Approved :: Apache Software License',
{%- elif cookiecutter.license == "Mozilla 2.0" %}
        'License :: OSI Approved :: Mozilla Public License 2.0 (MPL 2.0)',
        {%- endif %}
    ],
{%- if cookiecutter.entry_point == 'gui' or cookiecutter.entry_point == 'cli' %}
    entry_points={
    {%- if cookiecutter.entry_point == 'gui' %}
        'gui_scripts': [ {%- else %}
        'console_scripts': [
    {%- endif %}
            {%- if cookiecutter.is_aws_lambda == "no" %}
            '{{ cookiecutter.package_slug.replace('_', '-')  }} = {{ cookiecutter.package_slug }}.main:main',
            {%- else %}
            '{{ cookiecutter.package_slug }} = handler',
            {%- endif %}
        ],
    },
{% endif -%}
)
