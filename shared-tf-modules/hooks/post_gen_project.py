import os
import stat
import subprocess
from typing import List


def handleError(func, path, exc_info):
    print('Handling Error for file ', path)
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
    proc = subprocess.Popen(["ls", "-a"],
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE)
    stdout, stderr = proc.communicate()
    if proc.returncode != 0:
        raise Exception(f"{stderr.strip()} ErrorCode: {proc.returncode}")

    # Move generated module folders one level up after initializing git in them
    modules: List[bytes] = stdout.splitlines()
    excluded: List[str] = [".git", "..", "."]
    item: bytes
    for item in modules:
        item_to_move: str = item.decode("utf-8")
        if item_to_move not in excluded:
            subprocess.run(["cd", ".."])
            subprocess.run(["mv", item_to_move, '..'])

    print("""
################################################################################
################################################################################
    You have succesfully created `{{ cookiecutter.project_name }} shared TF modules`.
################################################################################
    You've used these cookiecutter parameters:
{% for key, value in cookiecutter.items()|sort %}
        {{ "{0:26}".format(key + ":") }} {{ "{0!r}".format(value).strip("u") }}
{%- endfor %}
################################################################################
    """)
