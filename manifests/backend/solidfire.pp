# == Class: manila::backend::solidfire
#
# Configures Manila share SolidFire driver.
# Parameters are particular to each share driver.
#
# === Parameters
#
# [*share_backend_name*]
#   (optional) Allows for the share_backend_name to be separate of $name.
#   Defaults to: $name
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
define manila::backend::solidfire(
  $san_ip,
  $san_login,
  $san_password,
  $share_backend_name = $name,
  $share_driver       = 'manila.share.drivers.solidfire.SolidFire',
  $sf_emulate_512      = true,
  $sf_allow_tenant_qos = false,
  $sf_account_prefix   = '',
  $sf_api_port         = '443'
) {

  manila_config {
    "${name}/share_backend_name": value => $share_backend_name;
    "${name}/share_driver":       value => $share_driver;
    "${name}/san_ip":              value => $san_ip;
    "${name}/san_login":           value => $san_login;
    "${name}/san_password":        value => $san_password;
    "${name}/sf_emulate_512":      value => $sf_emulate_512;
    "${name}/sf_allow_tenant_qos": value => $sf_allow_tenant_qos;
    "${name}/sf_account_prefix":   value => $sf_account_prefix;
    "${name}/sf_api_port":         value => $sf_api_port;
  }
}
