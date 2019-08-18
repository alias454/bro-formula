# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "bro/map.jinja" import host_lookup as config with context %}
{% if config.bro.bpf.use_BPFconf == 'True' %}

# Manage the <bro_base>/etc/bpf-bro.conf file
{{ config.bro.CfgDir }}/bpf-bro.conf:
  file.managed:
    - source: salt://bro/files/bpf-bro.conf
    - template: jinja
    - user: root
    - group: bro
    - mode: '0664'
    - watch_in:
      - service: service-bro

# Manage the <base_dir>/share/bro/bpfconf/__load__.bro file
{{ config.bro.ShareDir }}/bpfconf/__load__.bro:
  file.managed:
    - source: salt://bro/files/bpfconf/__load__.bro
    - template: jinja
    - user: root
    - group: bro
    - mode: '0664'
    - makedirs: true
    - watch_in:
      - service: service-bro

# Manage the <bro_base>/share/bro/bpfconf/bpfconf.bro file
{{ config.bro.ShareDir }}/bpfconf/bpfconf.bro:
  file.managed:
    - source: salt://bro/files/bpfconf/bpfconf.bro
    - template: jinja
    - user: root
    - group: bro
    - mode: '0664'
    - makedirs: true
    - watch_in:
      - service: service-bro

# Manage the <bro_base>/share/bro/bpfconf/interface.bro file
{{ config.bro.ShareDir }}/bpfconf/interface.bro:
  file.managed:
    - source: salt://bro/files/bpfconf/interface.bro
    - template: jinja
    - user: root
    - group: bro
    - mode: '0664'
    - makedirs: true
    - watch_in:
      - service: service-bro

# Manage the <bro_base>/share/bro/bpfconf/readfile.bro file
{{ config.bro.ShareDir }}/bpfconf/readfile.bro:
  file.managed:
    - source: salt://bro/files/bpfconf/readfile.bro
    - template: jinja
    - user: root
    - group: bro
    - mode: '0664'
    - makedirs: true
    - watch_in:
      - service: service-bro

# Manage the <bro_base>/share/bro/bpfconf/sensorname.bro file
{{ config.bro.ShareDir }}/bpfconf/sensorname.bro:
  file.managed:
    - source: salt://bro/files/bpfconf/sensorname.bro
    - template: jinja
    - user: root
    - group: bro
    - mode: '0664'
    - makedirs: true
    - watch_in:
      - service: service-bro

# Manage the <bro_base>/share/bro/bpfconf/sensortab.bro file
{{ config.bro.ShareDir }}/bpfconf/sensortab.bro:
  file.managed:
    - source: salt://bro/files/bpfconf/sensortab.bro
    - template: jinja
    - user: root
    - group: bro
    - mode: '0664'
    - makedirs: true
    - watch_in:
      - service: service-bro
{% endif %}
