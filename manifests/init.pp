# Class: manila
#
# == Parameters
#
# [*state_path*]
#   (optional) Directory for storing state.
#   Defaults to '/var/lib/manila'
#
# [*default_transport_url*]
#    (optional) A URL representing the messaging driver to use and its full
#    configuration. Transport URLs take the form:
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#    Defaults to $facts['os_service_default']
#
# [*rpc_response_timeout*]
#  (Optional) Seconds to wait for a response from a call.
#  Defaults to $facts['os_service_default']
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scope.
#   Defaults to $facts['os_service_default']
#
# [*executor_thread_pool_size*]
#   (Optional) Size of executor thread pool when executor is threading or eventlet.
#   Defaults to $facts['os_service_default'].
#
# [*package_ensure*]
#    (Optional) Ensure state for package.
#    Defaults to 'present'
#
# [*notification_transport_url*]
#   (optional) A URL representing the messaging driver to use for
#   notifications and its full configuration. Transport URLs
#   take the form:
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $facts['os_service_default'].
#
# [*notification_topics*]
#   (optional) AMQP topics to publish to when using the RPC notification driver.
#   (list value)
#   Default to $facts['os_service_default']
#
# [*notification_driver*]
#   (optional) Driver or drivers to handle sending notifications.
#   Defaults to 'messaging'
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ (x-ha-policy: all).
#   Defaults to  $facts['os_service_default'].
#
# [*rabbit_quorum_queue*]
#   (Optional) Use quorum queues in RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_transient_quorum_queue*]
#   (Optional) Use quorum queues for transients queues in RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_delivery_limit*]
#   (Optional) Each time a message is rdelivered to a consumer, a counter is
#   incremented. Once the redelivery count exceeds the delivery limit
#   the message gets dropped or dead-lettered.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_max_memory_length*]
#   (Optional) Limit the number of messages in the quorum queue.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_max_memory_bytes*]
#   (Optional) Limit the number of memory bytes used by the quorum queue.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_use_ssl*]
#   (Optional) Connect over SSL for RabbitMQ.
#   Defaults to $facts['os_service_default'].
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions.
#   Defaults to $facts['os_service_default']
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $facts['os_service_default']
#
# [*amqp_durable_queues*]
#   (optional) Use durable queues in amqp.
#   Defaults to $facts['os_service_default'].
#
# [*use_ssl*]
#   (optional) Enable SSL on the API server
#   Defaults to false, not set
#
# [*cert_file*]
#   (optional) Certificate file to use when starting API server securely
#   Defaults to false, not set
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to false, not set
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to false, not set_
#
# [*api_paste_config*]
#   (Optional) Allow Configuration of /etc/manila/api-paste.ini.
#
# [*storage_availability_zone*]
#   (optional) Availability zone of the node.
#   Defaults to 'nova'
#
# [*rootwrap_config*]
#   (optional) Path to the rootwrap configuration file to use for
#   running commands as root
#
# [*lock_path*]
#   (optional) Location to store Manila locks
#   Defaults to $::manila::params::lock_path
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the manila config.
#   Defaults to false.
#
# [*host*]
#   (optional) Name of this node. This can be an opaque identifier. It is
#   not necessarily a host name, FQDN, or IP address.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_in_pthread*]
#   (Optional) EXPERIMENTAL: Run the health check heartbeat thread
#   through a native python thread. By default if this
#   option isn't provided the  health check heartbeat will
#   inherit the execution model from the parent process. By
#   example if the parent process have monkey patched the
#   stdlib by using eventlet/greenlet then the heartbeat
#   will be run through a green thread.
#   Defaults to $facts['os_service_default']
#
# [*report_interval*]
#   (optional) Seconds between nodes reporting state to datastore.
#   Defaults to $facts['os_service_default']
#
# [*periodic_interval*]
#   (optional) Seconds between running periodic tasks.
#   Defaults to $facts['os_service_default']
#
# [*periodic_fuzzy_delay*]
#   (optional) Range of seconds to randomly delay when starting the periodic
#   task scheduler to reduce stampeding.
#   Defaults to $facts['os_service_default'].
#
class manila (
  $default_transport_url           = $facts['os_service_default'],
  $rpc_response_timeout            = $facts['os_service_default'],
  $control_exchange                = $facts['os_service_default'],
  $executor_thread_pool_size       = $facts['os_service_default'],
  $notification_transport_url      = $facts['os_service_default'],
  $notification_driver             = 'messaging',
  $notification_topics             = $facts['os_service_default'],
  $rabbit_ha_queues                = $facts['os_service_default'],
  $rabbit_quorum_queue             = $facts['os_service_default'],
  $rabbit_transient_quorum_queue   = $facts['os_service_default'],
  $rabbit_quorum_delivery_limit    = $facts['os_service_default'],
  $rabbit_quorum_max_memory_length = $facts['os_service_default'],
  $rabbit_quorum_max_memory_bytes  = $facts['os_service_default'],
  $rabbit_use_ssl                  = $facts['os_service_default'],
  $kombu_ssl_ca_certs              = $facts['os_service_default'],
  $kombu_ssl_certfile              = $facts['os_service_default'],
  $kombu_ssl_keyfile               = $facts['os_service_default'],
  $kombu_ssl_version               = $facts['os_service_default'],
  $kombu_failover_strategy         = $facts['os_service_default'],
  $amqp_durable_queues             = $facts['os_service_default'],
  $rabbit_heartbeat_in_pthread     = $facts['os_service_default'],
  $package_ensure                  = 'present',
  Boolean $use_ssl                 = false,
  $ca_file                         = false,
  $cert_file                       = false,
  $key_file                        = false,
  $api_paste_config                = '/etc/manila/api-paste.ini',
  $storage_availability_zone       = 'nova',
  $rootwrap_config                 = '/etc/manila/rootwrap.conf',
  $state_path                      = '/var/lib/manila',
  $lock_path                       = $::manila::params::lock_path,
  Boolean $purge_config            = false,
  $host                            = $facts['os_service_default'],
  $report_interval                 = $facts['os_service_default'],
  $periodic_interval               = $facts['os_service_default'],
  $periodic_fuzzy_delay            = $facts['os_service_default'],
) inherits manila::params {

  include manila::deps
  include manila::db

  if $use_ssl {
    if !$cert_file {
      fail('The cert_file parameter is required when use_ssl is set to true')
    }
    if !$key_file {
      fail('The key_file parameter is required when use_ssl is set to true')
    }
  }

  package { 'manila':
    ensure => $package_ensure,
    name   => $::manila::params::package_name,
    tag    => ['openstack', 'manila-package'],
  }

  resources { 'manila_config':
    purge => $purge_config,
  }

  oslo::messaging::rabbit { 'manila_config':
    rabbit_use_ssl                  => $rabbit_use_ssl,
    amqp_durable_queues             => $amqp_durable_queues,
    rabbit_ha_queues                => $rabbit_ha_queues,
    kombu_ssl_ca_certs              => $kombu_ssl_ca_certs,
    kombu_ssl_certfile              => $kombu_ssl_certfile,
    kombu_ssl_keyfile               => $kombu_ssl_keyfile,
    kombu_ssl_version               => $kombu_ssl_version,
    kombu_failover_strategy         => $kombu_failover_strategy,
    heartbeat_in_pthread            => $rabbit_heartbeat_in_pthread,
    rabbit_quorum_queue             => $rabbit_quorum_queue,
    rabbit_transient_quorum_queue   => $rabbit_transient_quorum_queue,
    rabbit_quorum_delivery_limit    => $rabbit_quorum_delivery_limit,
    rabbit_quorum_max_memory_length => $rabbit_quorum_max_memory_length,
    rabbit_quorum_max_memory_bytes  => $rabbit_quorum_max_memory_bytes,
  }

  oslo::messaging::default { 'manila_config':
    executor_thread_pool_size => $executor_thread_pool_size,
    transport_url             => $default_transport_url,
    rpc_response_timeout      => $rpc_response_timeout,
    control_exchange          => $control_exchange,
  }

  oslo::messaging::notifications { 'manila_config':
    transport_url => $notification_transport_url,
    driver        => $notification_driver,
    topics        => $notification_topics,
  }

  manila_config {
    'DEFAULT/api_paste_config':          value => $api_paste_config;
    'DEFAULT/storage_availability_zone': value => $storage_availability_zone;
    'DEFAULT/rootwrap_config':           value => $rootwrap_config;
    'DEFAULT/state_path':                value => $state_path;
    'DEFAULT/host':                      value => $host;
    'DEFAULT/report_interval':           value => $report_interval;
    'DEFAULT/periodic_interval':         value => $periodic_interval;
    'DEFAULT/periodic_fuzzy_delay':      value => $periodic_fuzzy_delay;
  }

  oslo::concurrency { 'manila_config': lock_path => $lock_path }

  # SSL Options
  if $use_ssl {
    manila_config {
      'DEFAULT/ssl_cert_file' : value => $cert_file;
      'DEFAULT/ssl_key_file' :  value => $key_file;
    }
    if $ca_file {
      manila_config { 'DEFAULT/ssl_ca_file' :
        value => $ca_file,
      }
    } else {
      manila_config { 'DEFAULT/ssl_ca_file' :
        ensure => absent,
      }
    }
  } else {
    manila_config {
      'DEFAULT/ssl_cert_file' : ensure => absent;
      'DEFAULT/ssl_key_file' :  ensure => absent;
      'DEFAULT/ssl_ca_file' :   ensure => absent;
    }
  }

}
