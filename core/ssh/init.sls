openssh:
  pkg.installed:
    - name: {{ salt['pillar.get']('pkgs:openssh', 'openssh-server') }}

sshguard:
  pkg.installed:
    - name: {{ salt['pillar.get']('pkgs:sshguard', 'sshguard') }}
  service.running:
    - enable: True
    - require:
      - pkg: sshguard
