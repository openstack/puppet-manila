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
class manila::quota (
  $shares             = $::os_service_default,
  $snapshots          = $::os_service_default,
  $gigabytes          = $::os_service_default,
  $driver             = $::os_service_default,
  $snapshot_gigabytes = $::os_service_default,
  $share_networks     = $::os_service_default,
  $share_replicas     = $::os_service_default,
  $replica_gigabytes  = $::os_service_default,
  $reservation_expire = $::os_service_default,
  $until_refresh      = $::os_service_default,
  $max_age            = $::os_service_default,
) {

  include manila::deps

  manila_config {
    'quota/shares':             value => $shares;
    'quota/snapshots':          value => $snapshots;
    'quota/gigabytes':          value => $gigabytes;
    'quota/driver':             value => $driver;
    'quota/snapshot_gigabytes': value => $snapshot_gigabytes;
    'quota/share_networks':     value => $share_networks;
    'quota/share_replicas':     value => $share_replicas;
    'quota/replica_gigabytes':  value => $replica_gigabytes;
    'quota/reservation_expire': value => $reservation_expire;
    'quota/until_refresh':      value => $until_refresh;
    'quota/max_age':            value => $max_age;
  }
}
