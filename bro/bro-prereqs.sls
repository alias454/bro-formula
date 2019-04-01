{% from "bro/map.jinja" import host_lookup as config with context %}

# Install epel for RHEL based systems
{% if salt.grains.get('os_family') == 'RedHat' %}
package-install-epel-bro:
  pkg.installed:
    - pkgs:
      - epel-release          # Base install
    - refresh: True

# Install prereqs for RHEL based systems
package-install-prereqs-bro:
  pkg.installed:
    - pkgs:
       - curl
       - gawk
       - bind-utils
       - gperftools
    - refresh: True

{% if config.package.install_type == 'tarball' %}
# The BRO yum package does not support GeoIP
# It must be configured at compile time.
# In most cases this will not be an issue
# One can do GeoIP lookups further upstream
 
# Install GeoIP on RHEL based systems
{% if config.bro.optional.use_LibgeoIP == 'True' %}
package-install-LibgeoIP-bro:
  pkg.installed:
    - pkgs:
      - GeoIP-devel
      - GeoIP-data
    - refresh: True
{% endif %} # End LibgeoIP
{% endif %} # End install_type

# Install prereqs for Debian based systems
{% elif salt.grains.get('os_family') == 'Debian' %}
package-install-prereqs-bro:
  pkg.installed:
    - pkgs:
       - curl
       - gawk
       - dnsutils
    - refresh: True
{% endif %} # End RedHat/Debian
