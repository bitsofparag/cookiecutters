# Cookiecutters

A few of my selected [Cookiecutter templates](https://cookiecutter.readthedocs.io/en/latest/).

# How to use

_The usage below is for `python_package` but you can replace it with other folder names as seen in this repository._

```shell
cookiecutter gh:bitsofparag/cookiecutters --directory python_package

# or if you have a local copy...

cookiecutter ${COOKIE_HOME} --directory python_package
# where $COOKIE_HOME is the path to local copy of cookiecutters.
```

The above command creates a `.cookiecutterrc` in the generated project.
You can use this rc file to patch the same project or clone new projects, like so:

```shell
cookiecutter --overwrite-if-exists \
  --no-input \
  --config-file=your-project-name/.cookiecutterrc \
  --directory=python_package \
  gh:bitsofparag/cookiecutters # or ${COOKIE_HOME}
```

_Replace "your-project-name" above with the correct name._
