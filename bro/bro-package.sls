{% from "bro/map.jinja" import host_lookup as config with context %}
{% if config.bro.install_type == 'package' %}

# Install bro from a package
package-install-bro:
  pkg.installed:
    - pkgs:
      - bro
    - refresh: True
    - require_in:
      - service: service-bro

{% endif %}
