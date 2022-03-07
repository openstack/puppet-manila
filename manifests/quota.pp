# == Class: manila::quota
#
# Setup and configure Manila quotas.
#
# === Parameters
#
# [*shares*]
#   (optional) Number of shares allowed per project.
#   Defaults to $::os_service_default.
#
# [*snapshots*]
#   (optional) Number of share snapshots allowed per project.
#   Defaults to $::os_service_default.
#
# [*gigabytes*]
#   (optional) Number of share gigabytes (snapshots are also included)
#   allowed per project. Defaults to $::os_service_default.
#
# [*driver*]
#   (optional) Default driver to use for quota checks.
#   Defaults to $::os_service_default.
#
# [*snapshot_gigabytes*]
#   (optional) Number of snapshot gigabytes allowed per project.
#   Defaults to $::os_service_default.
#
# [*share_networks*]
#   (optional) Number of share-networks allowed per project.
#   Defaults to $::os_service_default.
#
# [*share_replicas*]
#   (optional) Number of share-replicas allowed per project.
#   Defaults to $::os_service_default.
#
# [*replica_gigabytes*]
#   (optional) Number of replica gigabytes allowed per project.
#   Defaults to $::os_service_default.
#
# [*reservation_expire*]
#   (optional) Number of seconds until a reservation expires.
#   Defaults to $::os_service_default.
#
# [*until_refresh*]
#   (optional) Count of reservations until usage is refreshed.
#   Defaults to $::os_service_default.
#
# [*max_age*]
#   (optional) Number of seconds between subsequent usage refreshes.
#   Defaults to $:os_service_default.
#
# DEPRECATED PARAMETERS
#
# [*quota_shares*]
#   (optional) Number of shares allowed per project.
#   Defaults to undef.
#
# [*quota_snapshots*]
#   (optional) Number of share snapshots allowed per project.
#   Defaults to undef.
#
# [*quota_gigabytes*]
#   (optional) Number of share gigabytes (snapshots are also included)
#   allowed per project. Defaults to undef.
#
# [*quota_driver*]
#   (optional) Default driver to use for quota checks.
#   Defaults to undef.
#
# [*quota_snapshot_gigabytes*]
#   (optional) Number of snapshot gigabytes allowed per project.
#   Defaults to undef.
#
# [*quota_share_networks*]
#   (optional) Number of share-networks allowed per project.
#   Defaults to undef.
#
# [*quota_share_replicas*]
#   (optional) Number of share-replicas allowed per project.
#   Defaults to undef.
#
# [*quota_replica_gigabytes*]
#   (optional) Number of replica gigabytes allowed per project.
#   Defaults to undef.
#
class manila::quota (
  $shares                   = $::os_service_default,
  $snapshots                = $::os_service_default,
  $gigabytes                = $::os_service_default,
  $driver                   = $::os_service_default,
  $snapshot_gigabytes       = $::os_service_default,
  $share_networks           = $::os_service_default,
  $share_replicas           = $::os_service_default,
  $replica_gigabytes        = $::os_service_default,
  $reservation_expire       = $::os_service_default,
  $until_refresh            = $::os_service_default,
  $max_age                  = $::os_service_default,
  # DEPRECATED PARAMETERS
  $quota_shares             = undef,
  $quota_snapshots          = undef,
  $quota_gigabytes          = undef,
  $quota_driver             = undef,
  $quota_snapshot_gigabytes = undef,
  $quota_share_networks     = undef,
  $quota_share_replicas     = undef,
  $quota_replica_gigabytes  = undef,
) {

  include manila::deps

  [
    'shares', 'snapshots', 'gigabytes', 'driver', 'snapshot_gigabytes',
    'share_networks', 'share_replicas', 'replica_gigabytes'
  ].each |String $opt| {
    if getvar("quota_${opt}") != undef {
      warning("The quota_${opt} parameter is deprecated. Use the ${opt} parameter.")
    }
  }
  $shares_real = pick($quota_shares, $shares)
  $snapshots_real = pick($quota_snapshots, $snapshots)
  $gigabytes_real = pick($quota_gigabytes, $gigabytes)
  $driver_real = pick($quota_driver, $driver)
  $snapshot_gigabytes_real = pick($quota_snapshot_gigabytes, $snapshot_gigabytes)
  $share_networks_real = pick($quota_share_networks, $share_networks)
  $share_replicas_real = pick($quota_share_replicas, $share_replicas)
  $replica_gigabytes_real = pick($quota_replica_gigabytes, $replica_gigabytes)

  manila_config {
    'quota/shares':             value => $shares_real;
    'quota/snapshots':          value => $snapshots_real;
    'quota/gigabytes':          value => $gigabytes_real;
    'quota/driver':             value => $driver_real;
    'quota/snapshot_gigabytes': value => $snapshot_gigabytes_real;
    'quota/share_networks':     value => $share_networks_real;
    'quota/share_replicas':     value => $share_replicas_real;
    'quota/replica_gigabytes':  value => $replica_gigabytes_real;
    'quota/reservation_expire': value => $reservation_expire;
    'quota/until_refresh':      value => $until_refresh;
    'quota/max_age':            value => $max_age;
  }

  # TODO(tkajinam): Remove this after Xena release.
  manila_config {
    'DEFAULT/quota_shares':             ensure => absent;
    'DEFAULT/quota_snapshots':          ensure => absent;
    'DEFAULT/quota_gigabytes':          ensure => absent;
    'DEFAULT/quota_driver':             ensure => absent;
    'DEFAULT/quota_snapshot_gigabytes': ensure => absent;
    'DEFAULT/quota_share_networks':     ensure => absent;
    'DEFAULT/quota_share_replicas':     ensure => absent;
    'DEFAULT/quota_replica_gigabytes':  ensure => absent;
    'DEFAULT/reservation_expire':       ensure => absent;
    'DEFAULT/until_refresh':            ensure => absent;
    'DEFAULT/max_age':                  ensure => absent;
  }
}
