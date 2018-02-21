{% from "bro/map.jinja" import host_lookup as config with context %}
{% if config.bro.install_type == 'package' %}

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

{% endif %}
