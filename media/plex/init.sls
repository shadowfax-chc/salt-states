include:
  - nginx

plexmediaserver:
  pkg.installed:
    - sources:
      - plexmediaserver: https://downloads.plex.tv/plex-media-server/0.9.12.3.1173-937aac3/plexmediaserver_0.9.12.3.1173-937aac3_amd64.deb
  service.running:
    - enable: True

{% if salt['pillar.get']('plex:tmp_dir', False) %}
{{ salt['pillar.get']('plex:tmp_dir') }}:
  file.directory:
    - user: plex
    - group: plex
    - mode: 755 
    - makedirs: True
    - require:
      - pkg: plexmediaserver
    - watch_in:
      - service: plexmediaserver
{% endif %}

{% if salt['pillar.get']('plex:app_dir', False) %}
{{ salt['pillar.get']('plex:app_dir') }}:
  file.directory:
    - user: plex
    - group: plex
    - mode: 755 
    - makedirs: True
    - require:
      - pkg: plexmediaserver
    - watch_in:
      - service: plexmediaserver
{% endif %}

/etc/default/plexmediaserver:
  file.managed:
    - source: salt://media/plex/plex.default
    - template: jinja
    - require:
      - pkg: plexmediaserver
    - watch_in:
      - service: plexmediaserver

/etc/nginx/sites-available/plex.conf:
  file.managed:
    - source: salt://media/plex/plex.nginx.conf
    - template: jinja
    - require:
      - service: plexmediaserver
    - watch_in:
      - service: nginx

/etc/nginx/sites-enabled/plex.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/plex.conf
    - require:
      - file: /etc/nginx/sites-available/plex.conf
    - watch_in:
      - service: nginx
