# == Class: manila::share::san
#
# Configures Manila share SAN driver.
# Parameters are particular to each share driver.
#
# === Parameters
#
# [*share_driver*]
#   (required) Setup manila-share to use share driver.
#
# [*san_thin_provision*]
#   (optional) Use thin provisioning for SAN shares? Defaults to true.
#
# [*san_ip*]
#   (optional) IP address of SAN controller.
#
# [*san_login*]
#   (optional) Username for SAN controller. Defaults to 'admin'.
#
# [*san_password*]
#   (optional) Password for SAN controller.
#
# [*san_private_key*]
#   (optional) Filename of private key to use for SSH authentication.
#
# [*san_clustername*]
#   (optional) Cluster name to use for creating shares.
#
# [*san_ssh_port*]
#   (optional) SSH port to use with SAN. Defaults to 22.
#
# [*san_is_local*]
#   (optional) Execute commands locally instead of over SSH
#   use if the share service is running on the SAN device.
#
# [*ssh_conn_timeout*]
#   (optional) SSH connection timeout in seconds. Defaults to 30.
#
# [*ssh_min_pool_conn*]
#   (optional) Minimum ssh connections in the pool.
#
# [*ssh_min_pool_conn*]
#   (optional) Maximum ssh connections in the pool.
#
class manila::share::san (
  $share_driver,
  $san_thin_provision = true,
  $san_ip             = undef,
  $san_login          = 'admin',
  $san_password       = undef,
  $san_private_key    = undef,
  $san_clustername    = undef,
  $san_ssh_port       = 22,
  $san_is_local       = false,
  $ssh_conn_timeout   = 30,
  $ssh_min_pool_conn  = 1,
  $ssh_max_pool_conn  = 5
) {

  manila::backend::san { 'DEFAULT':
    share_driver       => $share_driver,
    san_thin_provision => $san_thin_provision,
    san_ip             => $san_ip,
    san_login          => $san_login,
    san_password       => $san_password,
    san_private_key    => $san_private_key,
    san_clustername    => $san_clustername,
    san_ssh_port       => $san_ssh_port,
    san_is_local       => $san_is_local,
    ssh_conn_timeout   => $ssh_conn_timeout,
    ssh_min_pool_conn  => $ssh_min_pool_conn,
    ssh_max_pool_conn  => $ssh_max_pool_conn,
  }
}
