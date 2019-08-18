bro-formula
===========

|img_travis|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/bro-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%

A saltstack formula to install BRO/Zeek Network Security Monitor on RHEL or Debian based systems.

Supports one capture interface at the moment. Adding ability to control multiple capture interfaces is on the TODO list

.. contents:: ^^Table of Contents^^
      :depth: 1

Optional
--------

Formulas exist to help with installation and management of
other components such as pf_ring.

pfring-formula  
https://github.com/saltstack-formulas/pfring-formula

Compile your own bro/zeek package using the guide `RPM package creation for BRO IDS Deployments https://alias454.com/rpm-package-creation-for-bro-ids-deployments/`_.

General notes
-------------

.. note::

    The ``FORMULA`` file, contains informtion about the version of this formula, tested OS and OS families, and the minimum tested version of salt.

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
----------------

.. contents::
    :local:

``bro``
^^^^^^^
^Meta-state (This is a state that includes other states)^.

Installs ^^bro^^ and it's requirements, manages the configuration file, and starts the service.

``bro.bro-repo``
^^^^^^^^^^^^^^^^
Manage repo files on RHEL/CentOS 7/Debian systems.

``bro.bro-prereqs``
^^^^^^^^^^^^^^^^^^^
Install prerequisite packages.

``bro.bro-package``
^^^^^^^^^^^^^^^^^^^
Install bro packages.

``bro.bro-config``
^^^^^^^^^^^^^^^^^^
Manage configuration file placement.

``bro.bro-bpfconf``
^^^^^^^^^^^^^^^^^^^
Manage BPF module and configuration.  
Supports a single bro-bpf.conf file that applies to all capture interfaces.

``bro.bro-sendmail``
^^^^^^^^^^^^^^^^^^^^
If using sendmail(postfix), manage relay host and service.

``bro.bro-service``
^^^^^^^^^^^^^^^^^^^
Manage bro service and a service to manage promiscuous mode of defined network interfaces on RHEL/CentOS 7/Debian systems.

``bro.bro-syslog``
^^^^^^^^^^^^^^^^^^^
Manage rsyslog config and service to send specifc log types to a remote collector.

``bro.bro-bropkg``
^^^^^^^^^^^^^^^^^^
Manage bro-pkg pip module and plugin installations.

``bro.bro-cron``
^^^^^^^^^^^^^^^^
Manage broctl cron entry.

Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

Test options
^^^^^^^^^^^^^

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^
Creates the docker instance and runs the ``bro`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^
Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^
Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^
Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^
Gives you SSH access to the instance for manual testing if automated testing fails.
