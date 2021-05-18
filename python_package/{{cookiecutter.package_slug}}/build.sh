#!/bin/bash
set -eou pipefail

PYTHON_VERSION={{cookiecutter.python_version}}
PYTHON_MM_VERSION={% set split_list = cookiecutter.python_version.split('.') %}{{split_list[0]}}.{{split_list[1]}}
PACKAGE_VERSION=${PACKAGE_VERSION:-0.1}
PAYLOAD_NAME=payload-$PACKAGE_VERSION.zip
TMP_VENV=tmp-venv

echo "[1/9] Cleaning cache"
mkdir -p dist
rm -rf dist/*
rm -rf $TMP_VENV
rm -rf *.log

echo "[2/9] Create a new tmp virtual env"
python${PYTHON_MM_VERSION} -m venv ./$TMP_VENV

echo "[3/9] Activating virtual env with python venv"
source $TMP_VENV/bin/activate

echo "[4/9] Installing dependencies"
pip install -r requirements.txt

echo "[5/9] Packaging dependencies"
PROJECT_ROOT=$(pwd)
cd $VIRTUAL_ENV/lib/python$PYTHON_MM_VERSION/site-packages/
zip -r9 $PROJECT_ROOT/dist/$PAYLOAD_NAME . -x 'easy_install.py' 'pip*' 'pkg_resources*' 'setuptools*'
cd -

echo "[6/9] Compiling and creating payload.zip"
if [[ -f setup.py ]]; then
    python setup.py sdist
    python setup.py bdist_wheel
    ls -l dist
else
  python3 -m compileall .
  zip -rg dist/$PAYLOAD_NAME {%- if cookiecutter.is_aws_lambda == "yes" -%}handler.py{%- else -%}main.py{% endif %} config utils # Append more modules
  zip -rg dist/$PAYLOAD_NAME . -i *.py  # Add python files
fi

echo "[7/9] Installing dev requirements in virtual env"
pip install -r requirements-dev.txt

echo "[8/9] Generating docs"
cd docs
make clean
make html
echo "Serve documentation from docs/build/html/"
cd -

echo "[9/9] Deactivating and removing tmp virtual env"
VIRTUAL_ENV_DISABLE_PROMPT=true deactivate
rm -rf $TMP_VENV

echo "===================="
echo "Finished!"
