# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "bro/map.jinja" import host_lookup as config with context %}

# Prior to enabling the service reload systemctl
systemd-reload-bro:
  cmd.run:
    - name: systemctl --system daemon-reload
    - onchanges:
      - file: /usr/lib/systemd/system/bro.service

# Make sure bro service is running and restart the service
service-bro:
  service.running:
    - name: bro
    - enable: True
    - watch:
      - file: {{ config.bro.CfgDir }}/broctl.cfg
      - file: {{ config.bro.CfgDir }}/node.cfg
      - file: {{ config.bro.CfgDir }}/networks.cfg
      - file: /usr/lib/systemd/system/bro.service
    {% if config.bro.interfaces.capture.enable == 'True' %}
      - network: network_configure_{{ config.bro.interfaces.capture.device_names }}
    {% endif %}
    - require:
      - cmd: systemd-reload-bro

# Make sure netcfg@ service is running and enabled
{% if config.bro.interfaces.capture.enable == 'True' %}
service-netcfg@{{ config.bro.interfaces.capture.device_names }}:
  service.running:
    - name: netcfg@{{ config.bro.interfaces.capture.device_names }}
    - enable: True
    - require:
      - file: /usr/lib/systemd/system/netcfg@.service
      - network: network_configure_{{ config.bro.interfaces.capture.device_names }}
{% endif %}
