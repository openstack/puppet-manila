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
    'DEFAULT/quota_shares':             value => $quota_shares;
    'DEFAULT/quota_snapshots':          value => $quota_snapshots;
    'DEFAULT/quota_gigabytes':          value => $quota_gigabytes;
    'DEFAULT/quota_driver':             value => $quota_driver;
    'DEFAULT/quota_snapshot_gigabytes': value => $quota_snapshot_gigabytes;
    'DEFAULT/quota_share_networks':     value => $quota_share_networks;
    'DEFAULT/quota_share_replicas':     value => $quota_share_replicas;
    'DEFAULT/quota_replica_gigabytes':  value => $quota_replica_gigabytes;
    'DEFAULT/reservation_expire':       value => $reservation_expire;
    'DEFAULT/until_refresh':            value => $until_refresh;
    'DEFAULT/max_age':                  value => $max_age;
  }
}
