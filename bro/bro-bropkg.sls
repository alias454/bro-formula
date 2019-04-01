{% from "bro/map.jinja" import host_lookup as config with context %}
{% if config.bro.use_BroPKG == 'True' %}
# bro-pkg is not bundled with the main install so we install it.

{% if salt.grains.get('os_family') == 'RedHat' %}
# Install prereqs for RHEL based systems
package-install-prereqs-bropkg:
  pkg.installed:
    - pkgs:
       - kernel-headers
       - kernel-devel
       - libpcap-devel
       - openssl-devel
       - python-devel
       - cmake
       - make
       - gcc
       - gcc-c++
    - refresh: True

# Install prereqs for Debian based systems
{% elif salt.grains.get('os_family') == 'Debian' %}
package-install-prereqs-bropkg:
  pkg.installed:
    - pkgs:
       - linux-headers-{{ kernel }}
       - libpcap-dev
       - libssl-dev
       - python-dev
       - cmake
       - make
       - gcc
       - g++
    - refresh: True
{% endif %} # End RedHat/Debian

# Install pip and other required packages
pip-install-bro:
  pkg.installed:
    - pkgs:
      - {{ config.bro.python_pip_pkg }}
    - refresh: True
    - unless: echo $(which bro-pkg) |grep "no bro-pkg"
    - require:
      - pkg: package-install-bro

# Upgrade older versions of pip
pip-upgrade-bro:
  cmd.run:
    - name: {{ config.bro.python_pip_cmd }} install --upgrade pip
    - onlyif: {{ config.bro.python_pip_cmd }} list --outdated |grep pip
    - unless: echo $(which bro-pkg) |grep "no bro-pkg"
    - require:
      - pkg: pip-install-bro

# Install the bro-pkg module
pip-package-install-bro-pkg:
  cmd.run:
    - name: {{ config.bro.python_pip_cmd }} install --upgrade bro-pkg
    - onlyif: {{ config.bro.python_pip_cmd }} list --outdated |grep bro-pkg
    - unless: echo $(which bro-pkg) |grep "no bro-pkg"
    - require:
      - pkg: package-install-bro
      - cmd: pip-upgrade-bro

# Run autoconfig
bro-pkg-autoconfig:
  cmd.run:
    - name: bro-pkg autoconfig
    - creates: /root/.bro-pkg/config
    - require:
      - cmd: pip-package-install-bro-pkg 

# Install plugins using bro-pkg
{% for pkg in config.bro.addon_plugins %}
bro-pkg-install-{{ pkg.plugin }}:
  cmd.run:
    - name: bro-pkg install {{ pkg.plugin }}
    - unless: bro-pkg list installed |grep {{ pkg.plugin }}
    - require:
      - cmd: pip-package-install-bro-pkg 
{% endfor %}
{% endif %}
