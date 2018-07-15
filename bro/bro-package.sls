{% from "bro/map.jinja" import host_lookup as config with context %}
{% if config.package.install_type == 'package' %}

# Install bro from a package
package-install-bro:
  pkg.installed:
    - pkgs:
      - bro
      - broctl
    - refresh: True
    - skip_verify: {{ config.package.skip_verify }}
    - require_in:
      - service: service-bro

{% elif config.package.install_type == 'local' %}

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

{% endif %}
