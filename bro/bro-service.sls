{% from "bro/map.jinja" import host_lookup as config with context %}

# Make sure bro service is running and restart the service unless
service-bro:
  service.running:
    - name: bro
    - enable: True
    - watch:
      - file: {{ config.bro.CfgDir }}/broctl.cfg
      - file: {{ config.bro.CfgDir }}/node.cfg
      - file: {{ config.bro.CfgDir }}/networks.cfg
      - file: /usr/lib/systemd/system/bro.service
      - network: network_configure_{{ config.bro.interfaces.capture.device_names }}

# Make sure netcfg@ service is running and enabled
service-netcfg@{{ config.bro.interfaces.capture.device_names }}:
  service.running:
    - name: netcfg@{{ config.bro.interfaces.capture.device_names }}
    - enable: True
    - require:
      - file: /usr/lib/systemd/system/netcfg@.service
      - network: network_configure_{{ config.bro.interfaces.capture.device_names }}
