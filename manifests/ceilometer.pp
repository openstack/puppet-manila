# == Class: manila::ceilometer
#
# Setup Manila to enable ceilometer can retrieve volume samples
# Ref: http://docs.openstack.org/developer/ceilometer/install/manual.html
#
# === Parameters
#
# [*notification_driver*]
#   (option) Driver or drivers to handle sending notifications.
#    Notice: rabbit_notifier has been deprecated in Grizzly, use rpc_notifier instead.
#


class manila::ceilometer (
  $notification_driver = 'manila.openstack.common.notifier.rpc_notifier'
) {

  manila_config {
    'DEFAULT/notification_driver':     value => $notification_driver;
  }
}

