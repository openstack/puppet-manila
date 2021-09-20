# == Class: manila::quota
#
# Setup and configure Manila quotas.
#
# === Parameters
#
# [*quota_shares*]
#   (optional) Number of shares allowed per project.
#   Defaults to $::os_service_default.
#
# [*quota_snapshots*]
#   (optional) Number of share snapshots allowed per project.
#   Defaults to $::os_service_default.
#
# [*quota_gigabytes*]
#   (optional) Number of share gigabytes (snapshots are also included)
#   allowed per project. Defaults to $::os_service_default.
#
# [*quota_driver*]
#   (optional) Default driver to use for quota checks.
#   Defaults to $::os_service_default.
#
# [*quota_snapshot_gigabytes*]
#   (optional) Number of snapshot gigabytes allowed per project.
#   Defaults to $::os_service_default.
#
# [*quota_share_networks*]
#   (optional) Number of share-networks allowed per project.
#   Defaults to $::os_service_default.
#
# [*quota_share_replicas*]
#   (optional) Number of share-replicas allowed per project.
#   Defaults to $::os_service_default.
#
# [*quota_replica_gigabytes*]
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
class manila::quota (
  $quota_shares             = $::os_service_default,
  $quota_snapshots          = $::os_service_default,
  $quota_gigabytes          = $::os_service_default,
  $quota_driver             = $::os_service_default,
  $quota_snapshot_gigabytes = $::os_service_default,
  $quota_share_networks     = $::os_service_default,
  $quota_share_replicas     = $::os_service_default,
  $quota_replica_gigabytes  = $::os_service_default,
  $reservation_expire       = $::os_service_default,
  $until_refresh            = $::os_service_default,
  $max_age                  = $::os_service_default,
) {

  include manila::deps

  manila_config {
    'quota/quota_shares':             value => $quota_shares;
    'quota/quota_snapshots':          value => $quota_snapshots;
    'quota/quota_gigabytes':          value => $quota_gigabytes;
    'quota/quota_driver':             value => $quota_driver;
    'quota/quota_snapshot_gigabytes': value => $quota_snapshot_gigabytes;
    'quota/quota_share_networks':     value => $quota_share_networks;
    'quota/quota_share_replicas':     value => $quota_share_replicas;
    'quota/quota_replica_gigabytes':  value => $quota_replica_gigabytes;
    'quota/reservation_expire':       value => $reservation_expire;
    'quota/until_refresh':            value => $until_refresh;
    'quota/max_age':                  value => $max_age;
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
