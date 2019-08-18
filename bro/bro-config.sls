# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "bro/map.jinja" import host_lookup as config with context %}

# Update the current path with bro path
/etc/profile.d/bro_path.sh:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        if [ -d "{{ config.bro.BinDir }}" ]; then
            PATH={{ config.bro.BinDir }}:$PATH
        fi

# Create group as a system group 
group-manage-bro:
  group.present:
    - name: bro
    - system: True

# Manage the <bro_base>/share/bro/site/local.bro file
{{ config.bro.ShareDir }}/site/local.bro:
  file.managed:
    - source: salt://bro/files/local.site
    - template: jinja
    - user: root
    - group: bro
    - mode: '0664'

# Manage the <bro_base>/etc/broctl.cfg
{{ config.bro.CfgDir }}/broctl.cfg:
  file.managed:
    - source: salt://bro/files/broctl.cfg
    - template: jinja
    - user: root
    - group: bro
    - mode: '0664'

# Manage the <bro_base>/etc/node.cfg file
{{ config.bro.CfgDir }}/node.cfg:
  file.managed:
    - source: salt://bro/files/node.cfg
    - template: jinja
    - user: root
    - group: bro
    - mode: '0664'

# Manage the <bro_base>/etc/networks.cfg file
{{ config.bro.CfgDir }}/networks.cfg:
  file.managed:
    - user: root
    - group: bro
    - mode: '0664'
    - contents: |
        # List of local networks in CIDR notation, optionally followed by a
        # descriptive tag.
        # For example, "10.0.0.0/8" or "fe80::/64" are valid prefixes.

        10.0.0.0/8          Private IP space
        172.16.0.0/12       Private IP space
        192.168.0.0/16      Private IP space
    - watch_in:
      - service: service-bro
        
# Configure network options
{% if config.bro.interfaces.capture.enable == 'True' %}
network_configure_{{ config.bro.interfaces.capture.device_names }}:
  network.managed:
    - name: {{ config.bro.interfaces.capture.device_names }}
    - enabled: True
    - retain_settings: True
    - type: eth
    - proto: none
    - autoneg: on
    - duplex: full
    - rx: off
    - tx: off
    - sg: off
    - tso: off
    - ufo: off
    - gso: off
    - gro: off
    - lro: off
{% endif %}

# Manage systemd unit file to control promiscuous mode
/usr/lib/systemd/system/netcfg@.service:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
    - contents: |
        [Unit]
        Description=Control promiscuous mode for interface %i
        After=network.target

        [Service]
        Type=oneshot
        ExecStart={{ config.bro.interfaces.ip_binary_path }} link set %i promisc on
        ExecStop={{ config.bro.interfaces.ip_binary_path }} link set %i promisc off
        RemainAfterExit=yes

        [Install]
        WantedBy=multi-user.target
        
# Manage systemd unit file to control bro
# https://gist.github.com/JustinAzoff/db71b901b1070a88f2d72738bf212749
/usr/lib/systemd/system/bro.service:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
    - contents: |
        [Unit]
        Description=Bro
        After=network.target

        [Service]
        ExecStartPre=-{{ config.bro.BinDir }}/broctl cleanup
        #ExecStartPre={{ config.bro.BinDir }}/broctl check
        #ExecStartPre={{ config.bro.BinDir }}/broctl install
        ExecStartPre={{ config.bro.BinDir }}/broctl deploy
        ExecStart={{ config.bro.BinDir }}/broctl start
        ExecStop={{ config.bro.BinDir }}/broctl stop
        RestartSec=10s
        Type=oneshot
        RemainAfterExit=yes

        [Install]
        WantedBy=multi-user.target
