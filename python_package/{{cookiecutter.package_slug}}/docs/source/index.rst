Welcome to {{cookiecutter.package_name}}'s documentation!
===================================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:

{%- if cookiecutter.is_aws_lambda == "yes" %}
handler.py
**********
.. automodule:: handler
   :members:
{%- else %}
main.py
**********
.. automodule:: main
   :members:
{%- endif %}

{%- if cookiecutter.include_custom_utils == "yes" %}
utils
*****
.. automodule:: utils
   :members:
{% endif %}

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
