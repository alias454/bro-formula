# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "bro/map.jinja" import host_lookup as config with context %}
{% if config.bro.optional.use_sendmail == 'True' %}

# Configure sendmail settings(defaults to using postfix sendmail)
bro_sendmail_config:
  file.replace:
    - name: /etc/postfix/main.cf
    - pattern: |
        #relayhost = \$mydomain
        .?relayhost = \[[a-zA-Z0-9.-:/]+\]
    - repl: |
        #relayhost = $mydomain
        relayhost = [{{ config.bro.optional.relayhost }}]

# Make sure postfix is running if use_sendmail is true
service-postfix-bro:
  service.running:
    - name: postfix
    - enable: True
    - watch:
      - file: bro_sendmail_config
{% endif %}
