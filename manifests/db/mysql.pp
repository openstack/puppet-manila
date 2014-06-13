# [*mysql_module*]
#   (optional) The puppet-mysql module version to use.
#   Tested versions include 0.9 and 2.2
#   Defaults to '0.9'
#
class manila::db::mysql (
  $password,
  $dbname        = 'manila',
  $user          = 'manila',
  $host          = '127.0.0.1',
  $allowed_hosts = undef,
  $charset       = 'utf8',
  $collate       = 'utf8_unicode_ci',
  $cluster_id    = 'localzone',
  $mysql_module  = '0.9'
) {

  Class['manila::db::mysql'] -> Exec<| title == 'manila-manage db_sync' |>

  if ($mysql_module >= 2.2) {
    Mysql_database[$dbname] ~> Exec<| title == 'manila-manage db_sync' |>

    mysql::db { $dbname:
      user         => $user,
      password     => $password,
      host         => $host,
      charset      => $charset,
      collate      => $collate,
      require      => Class['mysql::server'],
    }

  } else {
    Database[$dbname] ~> Exec<| title == 'manila-manage db_sync' |>

    mysql::db { $dbname:
      user         => $user,
      password     => $password,
      host         => $host,
      charset      => $charset,
      require      => Class['mysql::config'],
    }
  }


  # Check allowed_hosts to avoid duplicate resource declarations
  if is_array($allowed_hosts) and delete($allowed_hosts,$host) != [] {
    $real_allowed_hosts = delete($allowed_hosts,$host)
  } elsif is_string($allowed_hosts) and ($allowed_hosts != $host) {
    $real_allowed_hosts = $allowed_hosts
  }

  if $real_allowed_hosts {
    # TODO this class should be in the mysql namespace
    manila::db::mysql::host_access { $real_allowed_hosts:
      user          => $user,
      password      => $password,
      database      => $dbname,
      mysql_module  => $mysql_module,
    }
  }

}
