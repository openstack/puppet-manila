# The manila::db::mysql class creates a MySQL database for manila.
# It must be used on the MySQL server
#
# == Parameters
#
# [*password*]
#   (Required) password to connect to the database.
#
# [*dbname*]
#   (Optional) name of the database.
#   Defaults to manila.
#
# [*user*]
#   (Optional) user to connect to the database.
#   Defaults to manila.
#
# [*host*]
#   (Optional) the default source host user is allowed to connect from.
#   Defaults to 'localhost'
#
# [*allowed_hosts*]
#   (Optional) other hosts the user is allowed to connect from.
#   Defaults to undef.
#
# [*charset*]
#   (Optional) the database charset.
#   Defaults to 'utf8'
#
# [*collate*]
#   (Optional) the database collation.
#   Defaults to 'utf8_general_ci'
#
# [*cluster_id*]
#   (Optional) The cluster id.
#   Defaults to 'localzone'.
#
# [*mysql_module*]
#   (Optional) Deprecated.
#   Defaults to undef.
#
class manila::db::mysql (
  $password,
  $dbname        = 'manila',
  $user          = 'manila',
  $host          = '127.0.0.1',
  $allowed_hosts = undef,
  $charset       = 'utf8',
  $collate       = 'utf8_general_ci',
  $cluster_id    = 'localzone',
  $mysql_module  = undef,
) {

  include ::manila::deps

  if $mysql_module {
    warning('The mysql_module parameter is deprecated. The latest 2.x mysql module will be used.')
  }

  validate_string($password)

  ::openstacklib::db::mysql { 'manila':
    user          => $user,
    password_hash => mysql_password($password),
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  Anchor['manila::db::begin']
  ~> Class['manila::db::mysql']
  ~> Anchor['manila::db::end']
}
