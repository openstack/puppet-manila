# == Class: manila::share::solidfire
#
# Configures Manila share SolidFire driver.
# Parameters are particular to each share driver.
#
# === Parameters
#
# [*share_driver*]
#   (optional) Setup manila-share to use SolidFire share driver.
#   Defaults to 'manila.share.drivers.solidfire.SolidFire'
#
# [*san_ip*]
#   (required) IP address of SolidFire clusters MVIP.
#
# [*san_login*]
#   (required) Username for SolidFire admin account.
#
# [*san_password*]
#   (required) Password for SolidFire admin account.
#
# [*sf_emulate_512*]
#   (optional) Use 512 byte emulation for shares.
#   Defaults to True
#
# [*sf_allow_tenant_qos*]
#   (optional) Allow tenants to specify QoS via share metadata.
#   Defaults to False
#
# [*sf_account_prefix*]
#   (optional) Prefix to use when creating tenant accounts on SolidFire Cluster.
#   Defaults to None, so account name is simply the tenant-uuid
#
# [*sf_api_port*]
#   (optional) Port ID to use to connect to SolidFire API.
#   Defaults to 443
#
class manila::share::solidfire(
  $san_ip,
  $san_login,
  $san_password,
  $share_driver       = 'manila.share.drivers.solidfire.SolidFire',
  $sf_emulate_512      = true,
  $sf_allow_tenant_qos = false,
  $sf_account_prefix   = '',
  $sf_api_port         = '443'
) {

  manila::backend::solidfire { 'DEFAULT':
    san_ip              => $san_ip,
    san_login           => $san_login,
    san_password        => $san_password,
    share_driver        => $share_driver,
    sf_emulate_512      => $sf_emulate_512,
    sf_allow_tenant_qos => $sf_allow_tenant_qos,
    sf_account_prefix   => $sf_account_prefix,
    sf_api_port         => $sf_api_port,
  }
}
