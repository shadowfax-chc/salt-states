gorilla:
  pkg.installed:
    - name: {{ salt['pillar.get']('pkgs:gorilla', 'password-gorilla') }}
