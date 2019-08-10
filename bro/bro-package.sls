{% from "bro/map.jinja" import host_lookup as config with context %}
{% if config.package.install_type == 'package' %}

# Install bro from a package
package-install-bro:
  pkg.installed:
    - pkgs:
      - bro
      - broctl
    {% if salt.grains.get('os_family') == 'Debian' %}
      - bro-common
    {% endif %}
    - refresh: True
    - skip_verify: {{ config.package.skip_verify }}
    - require_in:
      - service: service-bro

{% elif config.package.install_type == 'local' %}
# Get package file from remote source and store it in salt://bro/files/
{% if config.package.use_remote_pkg == 'True' %}
{% for package in config.package.local_package %}
{{ package.files_path }}/{{ package.package }}.{{ package.type }}:
  file.managed:
    - source: {{ package.source_url }}/{{ package.package }}.{{ package.type }}
    - source_hash: {{ package.hash }}
    - reload_modules: true
    - user: root
    - group: root
    - mode: '0644'
    - onlyif: ls {{ package.files_path }}/{{ package.package }}.{{ package.type }} |grep 'No such file'
    - require_in:
      - pkg: package-install-bro
{% endfor %}
{% endif %}

# Install bro from a local package
package-install-bro:
  pkg.installed:
    - sources:
    {% for package in config.package.local_package %}
      - {{ package.name }}: salt://bro/files/{{ package.package }}.{{ package.type }}
    {% endfor %}
    - refresh: True
    - skip_verify: {{ config.package.skip_verify }}
    - require_in:
      - service: service-bro

# Make sure correct library paths are configured
# in case the installer fails to create them
/etc/ld.so.conf.d/bro-x86_64.conf:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        /opt/bro/lib
        /opt/bro/lib64
    - watch_in:
      - service: service-bro

# Run ldconfig after file is updated
ldconfig-bro:
  cmd.run:
    - name: ldconfig
    - onchanges:
      - file: /etc/ld.so.conf.d/bro-x86_64.conf

{% endif %}
