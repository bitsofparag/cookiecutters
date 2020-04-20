import io
from os import environ, path
from setuptools import setup, find_packages

AUTHOR = environ.get('AUTHOR', '{{cookiecutter.author_name}}')
AUTHOR_EMAIL = environ.get('AUTHOR_EMAIL', '{{cookiecutter.author_email}}')
PACKAGE_VERSION = environ.get('PACKAGE_VERSION', '{{cookiecutter.package_version}}')

here = path.abspath(path.dirname(__file__))
readme = io.open(path.join(here, 'README'), 'r', encoding='utf-8').read()


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
    url='https://{{cookiecutter.git_provider}}.com/{{cookiecutter.git_user_or_group_name}}/{{cookiecutter.package_slug}}.git',
    packages=find_packages(exclude=['test*']),
    python_requires='!=2.*, >3.0, >={{cookiecutter.python_version}}',
    setup_requires=['wheel'],
    include_package_data=True,
    zip_safe=False,
    install_requires=[
{%- if cookiecutter.package_deps != "e.g foo,bar>=3.0" -%}
  {%- set deps = cookiecutter.package_deps.split(',') -%}
  {%- for dep in deps %}
        '{{dep}}',
  {%- endfor -%}
{%- endif -%}
{%- if cookiecutter.sentry_dsn != "" %}
        'sentry-sdk>=0.14.3',
{%- endif -%}
{%- if cookiecutter.include_custom_logger == "yes" %}
        'colorlog>=4.1.0',
{%- endif %}
    ],
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
            '{{ cookiecutter.package_slug }} = {{ cookiecutter.package_slug }}.__main__:main',
        ],
    },
{% endif -%}
)
