# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "bro/map.jinja" import host_lookup as config with context %}

# Make sure cronie is installed
{% if salt.grains.get('os_family') == 'RedHat' %}
package-install-cronie-bro:
  pkg.installed:
    - pkgs:
      - cronie
    - refresh: True
{% elif salt.grains.get('os_family') == 'Debian' %}
{% endif %}

# Setup Cron for BRO runs every 5 minutes
{{ config.bro.BinDir }}/broctl cron:
  cron.present:
    - comment: "Check for Bro nodes that have crashed and general housekeeping"
    - identifier: "BRO_Check"
    - user: root
    - minute: '*/5'
