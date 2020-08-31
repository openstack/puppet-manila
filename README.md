Team and repository tags
========================

[![Team and repository tags](https://governance.openstack.org/tc/badges/puppet-manila.svg)](https://governance.openstack.org/tc/reference/tags/index.html)

<!-- Change things from this point on -->

manila
=======

#### Table of Contents

1. [Overview - What is the manila module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with manila](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Development - Guide for contributing to the module](#development)
6. [Contributors - Those with commits](#contributors)
7. [Release Notes - Release notes for the project](#release-notes)
8. [Repository - The project source code repository](#repository)

Overview
--------

The manila module is part of [OpenStack](https://opendev.org/openstack), an effort by the OpenStack infrastructure team to provide continuous integration testing and code review for OpenStack and OpenStack community projects as part of the core software.  The module itself is used to flexibly configure and manage the file system service for OpenStack.

Module Description
------------------

The manila module is a thorough attempt to make Puppet capable of managing the entirety of manila.  This includes manifests to provision such things as keystone endpoints, RPC configurations specific to manila, and database connections.

This module is tested in combination with other modules needed to build and leverage an entire OpenStack software stack.

Setup
-----

**What the manila module affects**

* [Manila](https://docs.openstack.org/manila/latest/), the file system service for OpenStack.

### Installing manila

    puppet module install openstack/manila

### Beginning with manila

To utilize the manila module's functionality you will need to declare multiple resources.  [TODO: add example]


Implementation
--------------

### manila

manila is a combination of Puppet manifests and ruby code to delivery configuration and extra functionality through types and providers.

### Types

#### manila_config

The `manila_config` provider is a children of the ini_setting provider. It allows one to write an entry in the `/etc/manila/manila.conf` file.

```puppet
manila_config { 'DEFAULT/api_paste_config' :
  value => /etc/manila/api-paste.ini,
}
```

This will write `api_paste_config=/etc/manila/api-paste.ini` in the `[DEFAULT]` section.

##### name

Section/setting name to manage from `manila.conf`

##### value

The value of the setting to be defined.

##### secret

Whether to hide the value from Puppet logs. Defaults to `false`.

##### ensure_absent_val

If value is equal to ensure_absent_val then the resource will behave as if `ensure => absent` was specified. Defaults to `<SERVICE DEFAULT>`

Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://docs.openstack.org/puppet-openstack-guide/latest/

Contributors
------------

* https://github.com/openstack/puppet-manila/graphs/contributors

Release Notes
-------------

* https://docs.openstack.org/releasenotes/puppet-manila

Repository
----------

* https://opendev.org/openstack/puppet-manila
