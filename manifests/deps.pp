# == Class: manila::deps
#
#  manila anchors and dependency management
#
class manila::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'manila::install::begin': }
  -> Package<| tag == 'manila-package'|>
  ~> anchor { 'manila::install::end': }
  -> anchor { 'manila::config::begin': }
  -> Manila_config<||>
  ~> anchor { 'manila::config::end': }
  -> anchor { 'manila::db::begin': }
  -> anchor { 'manila::db::end': }
  ~> anchor { 'manila::dbsync::begin': }
  -> anchor { 'manila::dbsync::end': }
  ~> anchor { 'manila::service::begin': }
  ~> Service<| tag == 'manila-service' |>
  ~> anchor { 'manila::service::end': }

  # paste-api.ini config should occur in the config block also.
  Anchor['manila::config::begin']
  -> Manila_api_paste_ini<||>
  ~> Anchor['manila::config::end']

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['manila::dbsync::begin']

  # policy config should occur in the config block also.
  Anchor['manila::config::begin']
  -> Openstacklib::Policy::Base<||>
  ~> Anchor['manila::config::end']

  # Support packages need to be installed in the install phase, but we don't
  # put them in the chain above because we don't want any false dependencies
  # between packages with the manila-package tag and the manila-support-package
  # tag.  Note: the package resources here will have a 'before' relationshop on
  # the manila::install::end anchor.  The line between manila-support-package and
  # manila-package should be whether or not manila services would need to be
  # restarted if the package state was changed.
  Anchor['manila::install::begin']
  -> Package<| tag == 'manila-support-package'|>
  -> Anchor['manila::install::end']

  # Support services need to be started in the service phase, but we don't
  # put them in the chain above because we don't want any false dependencies
  # between them and manila services. Note: the service resources here will
  # have a 'before' relationshop on the manila::service::end anchor.
  # The line between manila-support-service and manila-service should be
  # whether or not manila services would need to be restarted if the service
  # state was changed.
  Anchor['manila::service::begin']
  -> Service<| tag == 'manila-support-service'|>
  -> Anchor['manila::service::end']

  # We need openstackclient before marking service end so that manila
  # will have clients available to create resources. This tag handles the
  # openstackclient but indirectly since the client is not available in
  # all catalogs that don't need the client class (like many spec tests)
  Package<| tag == 'openstack'|>
  ~> Anchor['manila::service::end']

  # Installation or config changes will always restart services.
  Anchor['manila::install::end'] ~> Anchor['manila::service::begin']
  Anchor['manila::config::end']  ~> Anchor['manila::service::begin']
}


