# == Class: manila:scheduler::filter
#
# This class is aim to configure manila.scheduler filter
#
# === Parameters:
#
# [*default_filters*]
#   (Optional) List of filter class names to use for filtering hosts.
#   Defaults to $facts['os_service_default']
#
# [*default_weighers*]
#   (Optional) List of weigher class names to use for weighning hosts.
#   Defaults to $facts['os_service_default']
#
# [*default_share_group_filters*]
#   (Optional) List of filter class names to use for filtering hosts creating
#   share group.
#   Defaults to $facts['os_service_default']
#
# [*default_extend_filters*]
#   (Optional) List of filter class names to use for filtering hosts
#   extending share.
#   Defaults to $facts['os_service_default']
#
# [*pool_weight_multiplier*]
#   (Optional) Multiplier used for weighing existing share servers in a pool
#   Defaults to $facts['os_service_default']
#
# [*capacity_weight_multiplier*]
#   (Optional) Multiplier used for weighing share capacity.
#   Defaults to $facts['os_service_default']
#
class manila::scheduler::filter (
  $default_filters             = $facts['os_service_default'],
  $default_weighers            = $facts['os_service_default'],
  $default_share_group_filters = $facts['os_service_default'],
  $default_extend_filters      = $facts['os_service_default'],
  $pool_weight_multiplier      = $facts['os_service_default'],
  $capacity_weight_multiplier  = $facts['os_service_default'],
) {
  include manila::deps

  manila_config {
    'DEFAULT/scheduler_default_filters':
      value => join(any2array($default_filters),',');
    'DEFAULT/scheduler_default_weighers':
      value => join(any2array($default_weighers),',');
    'DEFAULT/scheduler_default_share_group_filters':
      value => join(any2array($default_share_group_filters),',');
    'DEFAULT/scheduler_default_extend_filters':
      value => join(any2array($default_extend_filters),',');
    'DEFAULT/pool_weight_multiplier':
      value => $pool_weight_multiplier;
    'DEFAULT/capacity_weight_multiplier':
      value => $capacity_weight_multiplier;
  }
}
