# Since there's only one manila_* type for API resources now,
# this probably could have all gone in the provider file.
# But maybe this is good long-term.
require 'puppet/provider/openstack'
require 'puppet/provider/openstack/auth'

class Puppet::Provider::Manila < Puppet::Provider::Openstack

  extend Puppet::Provider::Openstack::Auth

end
