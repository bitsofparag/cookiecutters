import os
import shutil
import subprocess
from subprocess import PIPE

if __name__ == "__main__":
    alb_arn = "{{cookiecutter.aws_alb_listener_arn}}"
    license_script = '''
    curl https://api.github.com/licenses \
      | jq -r '.[] \
      | select(.spdx_id == "{{cookiecutter.license}}") | .url' \
      | xargs -I{} curl {} \
      | jq -r '.body'
    '''
    process = subprocess.Popen(license_script, stdout=PIPE, shell=True)
    output, error = process.communicate()
    with open("LICENSE", "wb") as file:
        file.write(output)

    if alb_arn == "":  # if new alb created
        subprocess.run(["rm", "-rf", "../alb"])
        subprocess.run(["mv", "-f", "alb", ".."])
    else:
        dir_path = os.path.join(os.path.abspath(os.getcwd()), "alb")
        print(f"removing from {dir_path}")
        shutil.rmtree(dir_path)

    print("""
################################################################################
################################################################################
    You have succesfully created `{{ cookiecutter.service_name }}`.
################################################################################
    You've used these cookiecutter parameters:
{% for key, value in cookiecutter.items()|sort %}
        {{ "{0:26}".format(key + ":") }} {{ "{0!r}".format(value).strip("u") }}
{%- endfor %}
################################################################################
    """)
