{% from "bro/map.jinja" import host_lookup as config with context %}

# Setup Cron for BRO runs every 5 minutes
{{ config.bro.BinDir }}/broctl cron:
  cron.present:
    - comment: "Check for Bro nodes that have crashed and general housekeeping"
    - identifier: "BRO_Check"
    - user: root
    - minute: '*/5'
