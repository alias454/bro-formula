================
bro-formula
================

A saltstack formula to install BRO Network Security Monitor on RHEL based systems.

Supports one capture interface at the moment. Adding ability to control multiple capture interfaces is on the TODO list

Optional
================

Formulas exist to help with installation and management of
other components such as pf_ring.

pfring-formula
https://github.com/alias454/pfring-formula


Available states
================

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

.. contents::
    :local:

``bro-repo``
------------
Manage repo files on RHEL/CentOS 7 systems

``bro-prereqs``
------------
Install prerequisite packages

``bro-package``
------------
Install bro packages

``bro-config``
------------
Manage configuration file placement

``bro-bpfconf``
------------
Manage BPF module and configuration
Supports a single bro-bpf.conf file that applies to all capture interfaces

``bro-sendmail``
------------
If using sendmail(postfix), manage relay host and service

``bro-service``
------------
Manage bro service and a service to manage promiscuous mode of defined network interfaces on RHEL/CentOS 7 systems

``bro-cron``
------------
Manage broctl cron entry
