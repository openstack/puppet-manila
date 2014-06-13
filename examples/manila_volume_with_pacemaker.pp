# Example: managing manila controller services with pacemaker
#
# By setting enabled to false, these services will not be started at boot.  By setting
# manage_service to false, puppet will not kill these services on every run.  This
# allows the Pacemaker resource manager to dynamically determine on which node each
# service should run.
#
# The puppet commands below would ideally be applied to at least three nodes.
#
# Note that manila-api is associated with the virtual IP address as
# it is called from external services.  The remaining services connect to the
# database and/or message broker independently.
#
# Example pacemaker resource configuration commands (configured once per cluster):
#
# sudo pcs resource create manila_vip ocf:heartbeat:IPaddr2 params ip=192.0.2.3 \
#   cidr_netmask=24 op monitor interval=10s
#
# sudo pcs resource create manila_api_service lsb:openstack-manila-api
# sudo pcs resource create manila_scheduler_service lsb:openstack-manila-scheduler
#
# sudo pcs constraint colocation add manila_api_service with manila_vip

class { 'manila':
  database_connection  => 'mysql://manila:secret_block_password@openstack-controller.example.com/manila',
}

class { 'manila::api':
  keystone_password => 'CINDER_PW',
  keystone_user     => 'manila',
  enabled           => false,
  manage_service    => false,
}

class { 'manila::scheduler':
  scheduler_driver => 'manila.scheduler.simple.SimpleScheduler',
  enabled          => false,
  manage_service   => false,
}

