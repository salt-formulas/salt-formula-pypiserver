{%- from "pypiserver/map.jinja" import server with context %}

{%- if server.enabled %}

pypiserver_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

/srv/pypiserver:
  virtualenv.manage:
  - system_site_packages: False
  - requirements: salt://pypiserver/files/requirements.txt
  - require:
    - pkg: pypiserver_packages

pypiserver:
  user.present:
  - name: pypiserver
  - shell: /bin/bash
  - home: /srv/pypiserver
  - require:
    - virtualenv: /srv/pypiserver

pypiserver_dirs:
  file.directory:
  - names:
    - /srv/pypiserver/stable
    - /srv/pypiserver/unstable
    - /srv/pypiserver/private
    - /var/log/pypiserver
  - makedirs: true
  - user: pypiserver
  - group: pypiserver
  - require:
    - user: pypiserver

pypiserver_passwords:
  file.managed:
  - name: /srv/pypiserver/htpasswd.txt
  - source: salt://pypiserver/files/htpasswd.txt
  - mode: 755
  - template: jinja
  - require:
    - user: pypiserver

pypiserver_conf:
  file.managed:
  - name: /srv/pypiserver/paste.ini
  - source: salt://pypiserver/files/paste.ini
  - mode: 755
  - template: jinja
  - require:
    - user: pypiserver

{%- for env,packages in server.package.env.iteritems() %}
{%- for package_name,package in packages.iteritems() %}

pypiserver_{{ env }}_{{ package_name }}:
  cmd.run:
  - name: source /srv/pypiserver/bin/activate; {{ server.dir.base }}/bin/pip install {%- if package.source is defined %} -e git+{{ package.source }}{%- else %} -q --extra-index-url http://pypi.python.org/simple {{ package_name }}{%- endif %} -d /srv/pypiserver/{{ env }}
  - cwd: /srv/pypiserver
  - env:
      - 'PBR_VERSION': 'dummy'
{%- endfor %}
{%- endfor %}

{%- endif %}
