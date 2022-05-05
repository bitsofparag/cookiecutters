"""
Pre-gen Project.
Some sanity checks on user input before running cookiecutter
"""
import re

if __name__ == "__main__":
    service_name = "{{ cookiecutter.service_name }}"

    assert (bool(re.match(
        "^[A-Za-z0-9-]*$",
        service_name))), f"Only letters and - allowed in {service_name}"
