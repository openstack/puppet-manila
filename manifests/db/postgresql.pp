# == Class: manila::db::postgresql
#
# Class that configures postgresql for manila
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'manila'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'manila'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
class manila::db::postgresql (
  $password,
  $dbname     = 'manila',
  $user       = 'manila',
  $encoding   = undef,
  $privileges = 'ALL',
) {
  include manila::deps

  openstacklib::db::postgresql { 'manila':
    password   => $password,
    dbname     => $dbname,
    user       => $user,
    encoding   => $encoding,
    privileges => $privileges,
  }

  Anchor['manila::db::begin']
  ~> Class['manila::db::postgresql']
  ~> Anchor['manila::db::end']
}
