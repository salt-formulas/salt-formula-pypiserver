{%- if pillar.pypiserver is defined %}
include:
{%- if pillar.pypiserver.server is defined %}
- pypiserver.server
{%- endif %}
{%- endif %}
