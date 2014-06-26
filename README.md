manila  #NTAP: this needs to be completely replaced
=======

4.0.0 - 2014.1.0 - Icehouse

#### Table of Contents

1. [Overview - What is the manila module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with manila](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors - Those with commits](#contributors)
8. [Release Notes - Notes on the most recent updates to the module](#release-notes)

Overview
--------

The manila module is a part of [Stackforge](https://github.com/stackfoge), an effort by the Openstack infrastructure team to provide continuous integration testing and code review for Openstack and Openstack community projects not part of the core software.  The module its self is used to flexibly configure and manage the block storage service for Openstack.

Module Description
------------------

The manila module is a thorough attempt to make Puppet capable of managing the entirety of manila.  This includes manifests to provision such things as keystone endpoints, RPC configurations specific to manila, and database connections.  Types are shipped as part of the manila module to assist in manipulation of configuration files.

This module is tested in combination with other modules needed to build and leverage an entire Openstack software stack.  These modules can be found, all pulled together in the [openstack module](https://github.com/stackfoge/puppet-openstack).

Setup
-----

**What the manila module affects**

* manila, the block storage service for Openstack.

### Installing manila

    puppet module install puppetlabs/manila

### Beginning with manila

To utilize the manila module's functionality you will need to declare multiple resources.  The following is a modified excerpt from the [openstack module](https://github.com/stackfoge/puppet-openstack).  This is not an exhaustive list of all the components needed, we recommend you consult and understand the [openstack module](https://github.com/stackforge/puppet-openstack) and the [core openstack](http://docs.openstack.org) documentation.

**Define a manila control node**

```puppet
class { 'manila':
  database_connection     => 'mysql://manila:secret_block_password@openstack-controller.example.com/manila',
  rabbit_password         => 'secret_rpc_password_for_blocks',
  rabbit_host             => 'openstack-controller.example.com',
  verbose                 => true,
}

class { 'manila::api':
  keystone_password       => $keystone_password,
  keystone_enabled        => $keystone_enabled,
  keystone_user           => $keystone_user,
  keystone_auth_host      => $keystone_auth_host,
  keystone_auth_port      => $keystone_auth_port,
  keystone_auth_protocol  => $keystone_auth_protocol,
  service_port            => $keystone_service_port,
  package_ensure          => $manila_api_package_ensure,
  bind_host               => $manila_bind_host,
  enabled                 => $manila_api_enabled,
}

class { 'manila::scheduler':
  scheduler_driver => 'manila.scheduler.simple.SimpleScheduler',
}
```

**Define a manila storage node**

```puppet
class { 'manila':
  database_connection     => 'mysql://manila:secret_block_password@openstack-controller.example.com/manila',
  rabbit_password         => 'secret_rpc_password_for_blocks',
  rabbit_host             => 'openstack-controller.example.com',
  verbose                 => true,
}

class { 'manila::share': }

class { 'manila::share::iscsi':
  iscsi_ip_address => '10.0.0.2',
}
```

**Define a manila storage node with multiple backends **

```puppet
class { 'manila':
  database_connection     => 'mysql://manila:secret_block_password@openstack-controller.example.com/manila',
  rabbit_password         => 'secret_rpc_password_for_blocks',
  rabbit_host             => 'openstack-controller.example.com',
  verbose                 => true,
}

class { 'manila::share': }

manila::backend::iscsi {'iscsi1':
  iscsi_ip_address => '10.0.0.2',
}

manila::backend::iscsi {'iscsi2':
  iscsi_ip_address => '10.0.0.3',
}

manila::backend::iscsi {'iscsi3':
  iscsi_ip_address    => '10.0.0.4',
  share_backend_name => 'iscsi',
}

manila::backend::iscsi {'iscsi4':
  iscsi_ip_address    => '10.0.0.5',
  share_backend_name => 'iscsi',
}

manila::backend::rbd {'rbd-images':
  rbd_pool => 'images',
  rbd_user => 'images',
}

# Manila::Type requires keystone credentials
Manila::Type {
  os_password     => 'admin',
  os_tenant_name  => 'admin',
  os_username     => 'admin',
  os_auth_url     => 'http://127.0.0.1:5000/v2.0/',
}

manila::type {'iscsi':
  set_key   => 'share_backend_name',
  set_value => ['iscsi1', 'iscsi2', 'iscsi']
}

manila::type {'rbd':
  set_key   => 'share_backend_name',
  set_value => 'rbd-images',
}

class { 'manila::backends':
  enabled_backends => ['iscsi1', 'iscsi2', 'rbd-images']
}
```

Note: that the name passed to any backend resource must be unique accross all backends otherwise a duplicate resource will be defined.

** Using type and type_set **

Manila allows for the usage of type to set extended information that can be used for various reasons. We have resource provider for ``type`` and ``type_set`` Since types are rarely defined with out also setting attributes with it, the resource for ``type`` can also call ``type_set`` if you pass ``set_key`` and ``set_value``


Implementation
--------------

### manila

manila is a combination of Puppet manifest and ruby code to delivery configuration and extra functionality through types and providers.

Limitations
------------

* Setup of storage nodes is limited to Linux and LVM, i.e. Puppet won't configure a Nexenta appliance but nova can be configured to use the Nexenta driver with Class['manila::share::nexenta'].

* The Manila Openstack service depends on a sqlalchemy database. If you are using puppetlabs-mysql to achieve this, there is a parameter called mysql_module that can be used to swap between the two supported versions: 0.9 and 2.2. This is needed because the puppetlabs-mysql module was rewritten and the custom type names have changed between versions.
Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://wiki.openstack.org/wiki/Puppet-openstack#Developer_documentation

Contributors
------------

* https://github.com/stackforge/puppet-manila/graphs/contributors

Release Notes
-------------

**4.0.0**

* Stable Icehouse release.
* Updated NetApp unified driver config options.
* Updated support for latest RabbitMQ module.
* Added Glance support.
* Added GlusterFS driver support.
* Added region support.
* Added support for MySQL module (>= 2.2).
* Added support for Swift and Ceph backup backend.
* Added manila::config to handle additional custom options.
* Refactored duplicate code for single and multiple backends.
* Removed control exchange flag.
* Removed deprecated manila::base class.

**3.1.1**

* Fixed resource duplication bug.

**3.1.0**

* Added default_share_type as a Manila API parameter.
* Added parameter for endpoint procols.
* Deprecated glance_api_version.
* Added support for VMDK.
* Added support for Manila multi backend.
* Added support for https authentication endpoints.
* Replaced pip with native package manager (VMDK).

**3.0.0**

* Major release for OpenStack Havana.
* Added support for SolidFire.
* Added support for ceilometer.
* Fixed bug for manila-share requirement.

**2.2.0**

* Added support for rate limiting via api-paste.ini
* Added support to configure control_exchange.
* Added parameter check to enable or disable db_sync.
* Added syslog support.
* Added default auth_uri setting for auth token.
* Set package defaults to present.
* Fixed a bug to create empty init script when necessary.
* Various lint fixes.

**2.1.0**

* Added configuration of Manila quotas.
* Added support for NetApp direct driver backend.
* Added support for ceph backend.
* Added support for SQL idle timeout.
* Added support for RabbitMQ clustering with single IP.
* Fixed allowed_hosts/database connection bug.
* Fixed lvm2 setup failure for Ubuntu.
* Removed unnecessary mysql::server dependency.
* Pinned RabbitMQ and database module versions.
* Various lint and bug fixes.

**2.0.0**

* Upstream is now part of stackfoge.
* Nexenta, NFS, and SAN support added as manila share drivers.
* Postgres support added.
* The Apache Qpid and the RabbitMQ message brokers available as RPC backends.
* Configurability of scheduler_driver.
* Various cleanups and bug fixes.
