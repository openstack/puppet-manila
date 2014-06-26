# == Class: manila::backend::san
#
# Configures Manila share SAN driver.
# Parameters are particular to each share driver.
#
# === Parameters
#
# [*share_driver*]
#   (required) Setup manila-share to use share driver.
#
# [*share_backend_name*]
#   (optional) Allows for the share_backend_name to be separate of $name.
#   Defaults to: $name
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
define manila::backend::san (
  $share_driver,
  $share_backend_name = $name,
  $san_thin_provision  = true,
  $san_ip              = undef,
  $san_login           = 'admin',
  $san_password        = undef,
  $san_private_key     = undef,
  $san_clustername     = undef,
  $san_ssh_port        = 22,
  $san_is_local        = false,
  $ssh_conn_timeout    = 30,
  $ssh_min_pool_conn   = 1,
  $ssh_max_pool_conn   = 5
) {

  manila_config {
    "${name}/share_backend_name": value => $share_backend_name;
    "${name}/share_driver":       value => $share_driver;
    "${name}/san_thin_provision":  value => $san_thin_provision;
    "${name}/san_ip":              value => $san_ip;
    "${name}/san_login":           value => $san_login;
    "${name}/san_password":        value => $san_password;
    "${name}/san_private_key":     value => $san_private_key;
    "${name}/san_clustername":     value => $san_clustername;
    "${name}/san_ssh_port":        value => $san_ssh_port;
    "${name}/san_is_local":        value => $san_is_local;
    "${name}/ssh_conn_timeout":    value => $ssh_conn_timeout;
    "${name}/ssh_min_pool_conn":   value => $ssh_min_pool_conn;
    "${name}/ssh_max_pool_conn":   value => $ssh_max_pool_conn;
  }
}
