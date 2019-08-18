# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "bro/map.jinja" import host_lookup as config with context %}
{% if config.package.install_type == 'package' %}
# Installing from package

# Configure repo file for RHEL based systems
{% if salt.grains.get('os_family') == 'RedHat' %}
{% if config.package.use_repo == 'True' %}
# The Bro Network Security Monitor (RHEL)
bro_repo:
  pkgrepo.managed:
    - name: bro
    - type: rpm-md
    - baseurl: {{ config.package.repo_baseurl }}
    - gpgcheck: 1
    - gpgkey: {{ config.package.repo_gpgkey }}
    - enabled: 1
{% endif %}

# Configure repo file for Debian based systems
{% elif salt.grains.get('os_family') == 'Debian' %}
{% if config.package.use_repo == 'True' %}
# Import keys for bro
command-apt-key-bro:
  cmd.run:
    - name: apt-key adv --fetch-keys {{ config.package.repo_gpgkey }}
    - unless: apt-key list |grep network@build.opensuse.org

# The Bro Network Security Monitor (Debian)
bro_repo:
  pkgrepo.managed:
    - name: {{ config.package.repo_baseurl }} /
    - file: /etc/apt/sources.list.d/bro.list
    - gpgcheck: 1
    - key_url: {{ config.package.repo_gpgkey }}
    - disabled: True
{% endif %}
{% endif %}
{% endif %}
