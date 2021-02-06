import os
import shutil
import stat
import pathlib
import subprocess
from os.path import join


def handleError(func, path, exc_info):
    print('Handling Error for file ' , path)
    print(exc_info)
    # If file has access issue...
    if not os.access(path, os.W_OK):
       # ...change the permission of the file
       os.chmod(path, stat.S_IWUSR)
       # ...and call the calling function again
       func(path)


def unlink_if_exists(path):
    if os.path.exists(path):
        os.unlink(path)


if __name__ == "__main__":
    package_src = "{{cookiecutter.package_slug}}"
    include_custom_utils = "{{cookiecutter.include_custom_utils}}"
    is_aws_lambda = "{{cookiecutter.is_aws_lambda}}"
    dist_packager = "{{cookiecutter.dist_packager}}"
    build_script = "{{cookiecutter.build_script}}"
    code_formatter = "{{cookiecutter.code_formatter}}"

    if include_custom_utils == "no":
        # Keep the config directory but remove the logging.json file
        unlink_if_exists('config/logging.json')

        # Delete all contents of a directory and handle errors
        shutil.rmtree('utils', onerror=handleError)

    if is_aws_lambda == "no":
        # Remove handler.py file
        unlink_if_exists('handler.py')
        if pathlib.Path("utils").exists():
            subprocess.run(["cp", "-rf", "utils", package_src])
            shutil.rmtree('utils', onerror=handleError)
        if pathlib.Path("config").exists():
            subprocess.run(["cp", "-rf", "config", package_src])
            shutil.rmtree('config', onerror=handleError)
        if pathlib.Path("sample_data.json").exists():
            subprocess.run(["cp", "-rf", "sample_data.json", package_src])
            subprocess.run(["rm", "sample_data.json"])
    else:
        shutil.rmtree(package_src, onerror=handleError)

    if dist_packager == "compileall":
        unlink_if_exists('setup.py')
        unlink_if_exists('setup.cfg')

    if build_script == "build.sh":
        unlink_if_exists('Makefile')
    else:
        unlink_if_exists('build.sh')

    if code_formatter != "yapf":
        # .style.yapf file if we are not using yapf
        unlink_if_exists('.style.yapf')


    print("""
################################################################################
################################################################################
    You have succesfully created `{{ cookiecutter.package_name }}`.
################################################################################
    You've used these cookiecutter parameters:
{% for key, value in cookiecutter.items()|sort %}
        {{ "{0:26}".format(key + ":") }} {{ "{0!r}".format(value).strip("u") }}
{%- endfor %}
################################################################################
    """)
