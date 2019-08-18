# -*- coding: utf-8 -*-
# vim: ft=yaml
---
# BRO docs https://www.bro.org/documentation/index.html
bro:
  lookup:
    package:
    {% if grains['os_family'] == 'RedHat' %}
      install_type: 'local'                         # Install type can be package or local (support for tarball not implemented) 
      local_package:                                # Can be multiple packages like bro, broctl, broccoli etc.
        - pack_id: 'bro-full'
          package: 'Bro-2.6-195-Linux-x86_64'       # Custom package to be deployed
          name: 'bro'                               # Name of installed package
          type: 'rpm'                               # Type should be deb or rpm based on platform
          source: 'https://gist.github.com/alias454/2fab378323e712b4c80ad6fb667696b2/raw' # Link to alias454 gist where test package lives (no trailing /)
      use_repo: 'False'                             # Bro can be installed from epel or a local rpm not just bro repos
      repo_baseurl: 'http://download.opensuse.org/repositories/network:/bro/CentOS_7/'
      repo_gpgkey: 'http://download.opensuse.org/repositories/network:/bro/CentOS_7/repodata/repomd.xml.key'
      skip_verify: '0'
    {% elif grains['os_family'] == 'Debian' %}
      install_type: 'package'                       # Install type can be package (support for tarball or local not implemented) 
      use_repo: 'False'                             # Debian 9 does not require an external repo
      repo_baseurl: 'deb http://download.opensuse.org/repositories/network:/bro/Debian_8.0/'
      repo_gpgkey: 'http://download.opensuse.org/repositories/network:bro/Debian_8.0/Release.key'
      skip_verify: '0'
    {% endif %}
    bro:
    {% if grains['os_family'] == 'RedHat' %}
      python_pip_pkg: 'python36-pip'         # Can be pip or pip3 but only gets installed if use_BroPKG == True
    {% elif grains['os_family'] == 'Debian' %}
      python_pip_pkg: 'python3-pip'         # Can be pip or pip3 but only gets installed if use_BroPKG == True
    {% endif %}
      python_pip_cmd: 'pip3'                 # Otherwise, the pip install is skipped and bro-pkg is not configured
    {% if grains['osfinger'] == 'Ubuntu-16.04' %} #Ubuntu 16 throws an error for now disabling this until fixed
      use_BroPKG: 'False'                    # Use bro-pkg to manage plugins (requird for plugins such as af_packet etc)
    {% else %}
      use_BroPKG: 'False'                    # Use bro-pkg to manage plugins (requird for plugins such as af_packet etc)
    {% endif %}
      addon_plugins:                         # List of plugins to install if bro-pkg is enabled 
        - plugin: 'bro-af_packet-plugin'     # af_packet is required when use_afpacket == True
      MailTo: 'root@localhost'               # Recipient address for all emails sent out by Bro and BroControl
      SendMail: '/sbin/sendmail'             # Path to sendmail binary
      MailConnectionSummary: '1'             # Send mail connection summaries
      MinDiskSpace: '5'                      # Threshold (in percentage of disk space) for HDD where SpoolDir lives
      MailHostUpDown: '1'                    # Send mail when "broctl cron" notices a host in the cluster has changed
      LogRotationInterval: '3600'            # Log rotation interval in seconds for current logs
      LogExpireInterval: '0'                 # Files older than this will be deleted by "broctl cron" 0 is never
      StatsLogEnable: '1'                    # Enable BroControl to write statistics to the stats.log file
      StatsLogExpireInterval: '0'            # Number of days that entries in the stats.log file are kept
      StatusCmdShowAll: '0'                  # Show all output of the broctl status command
      CrashExpireInterval: '0'               # Number of days that crash directories are kept
      SitePolicyScripts: 'local.bro'         # Site-specific policy script to load
    {% if grains['os_family'] == 'RedHat' %}
      base_dir: '/opt/bro'                   # /opt/bro is default for yum package install
    {% elif grains['os_family'] == 'Debian' %}
      base_dir: '/usr/bin'                   # /usr/bin is default for deb package install
      BinDir: '/usr/bin'                     # Default location of executables on Debian
      LogDir: '/var/log/bro'                 # Default location of log directory on Debian
      SpoolDir: '/var/spool/bro'             # Default location of spool directory on Debian
      CfgDir: '/etc/bro'                     # Default config directory location for Debian
      ShareDir: '/usr/share/bro'             # Location of shared resources (site local)
    {% endif %}
      mode: 'standalone'                     # Mode can be standalone or lb_cluster (load balanced cluster) 
      use_pfring: 'False'                    # If pf_ring is installed set this to True. Must use "pf_ring" lb_method
      use_afpacket: 'True'                   # If you use AF_PACKET set this to True. Must use "custom" lb_method and use_BroPKG set to True
      lb_method: 'custom'                    # Load balancer type ("pf_ring" or "custom" are supported)
      lb_procs: '2'                          # Number of processors to run BRO workers with
      logging:
        use_rsyslog: 'False'                 # Enable rsyslog usage
      bpf:
      {% if grains['osfinger'] == 'Ubuntu-16.04' %} #Ubuntu 16 throws an error for now disabling this until fixed
        use_BPFconf: 'False'                 # Use Berkeley Packet Filter(BPF) on capture interfaces
      {% else %}
        use_BPFconf: 'True'                  # Use Berkeley Packet Filter(BPF) on capture interfaces
      {% endif %}
        bpf_rules: []                        # Add custom BPF rules
      optional:
        use_LibgeoIP: 'False'                # Use LibgeoIP(less useful if sending logs upstream)
        use_sendmail: 'False'                # Use sendmail(needs sendmail/postfix to be installed)
        relayhost: 'mail.domain.tld'         # Send email to a relay host
      interfaces:
        ip_binary_path: '/sbin/ip'           # path to ip binary for managing 
        management: 'eth0'                 # Management interface name
        capture:
          enable: 'False'
          device_names: 'eth0'             # Capture interface name (currently only supports 1 interface)
          enable_tx: '0'                     # Enable tx send on this interface (default is 0)
          min_num_slots: '4096'              # Min Slots check support on card using ethtool -g eth1
