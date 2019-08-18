# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "bro/map.jinja" import host_lookup as config with context %}
{% if config.bro.logging.use_rsyslog == 'True' %}

# Configure rsyslog settings for sending bro logs to a remote log collector
bro_rsyslog_config:
  file.managed:
    - name: /etc/rsyslog.d/00-bro.conf
    - source: salt://bro/files/rsyslog_00-bro.conf
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

{% if salt.grains.get('os_family') == 'RedHat' %}
command-semanage-{{ config.bro.logging.protocol }}-{{ config.bro.logging.port }}-rsyslog-port:
  cmd.run:
    - name: semanage port -a -t syslogd_port_t -p {{ config.bro.logging.protocol }} {{ config.bro.logging.port }} 
    - unless: semanage port -l |grep syslog |grep {{ config.bro.logging.port }}
    - require-in:
      - service: service-rsyslog-bro
    - require:
      - pkg: package-install-bro
{% endif %}

# Make sure rsyslog is running if use_rsyslog is true
service-rsyslog-bro:
  service.running:
    - name: rsyslog
    - enable: True
    - watch:
      - file: bro_rsyslog_config
{% endif %}
