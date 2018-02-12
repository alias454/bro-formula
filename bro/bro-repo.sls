{% from "bro/map.jinja" import host_lookup as config with context %}
{% if config.bro.install_type == 'package' %}
# Installing from package

# Configure repo file for RHEL based systems
{% if salt.grains.get('os_family') == 'RedHat' %}
bro_repo:
  pkgrepo.managed:
    - name: bro
    - type: rpm-md
    - comments: |
        # Managed by Salt Do not edit
        # The Bro Network Security Monitor (CentOS_7) 
    - baseurl: {{ config.bro.repo_baseurl }}
    - gpgcheck: 1
    - gpgkey: {{ config.bro.repo_gpgkey }}
    - enabled: 1

{% endif %}
{% endif %}
