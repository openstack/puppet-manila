File.expand_path('../../../../openstacklib/lib', File.dirname(__FILE__)).tap { |dir| $LOAD_PATH.unshift(dir) unless $LOAD_PATH.include?(dir) }

require 'puppet/util/inifile'
require 'puppet/provider/openstack'
require 'puppet/provider/openstack/auth'
require 'puppet/provider/openstack/credentials'

class Puppet::Provider::Manila < Puppet::Provider::Openstack

  extend Puppet::Provider::Openstack::Auth

  def self.conf_filename
    '/etc/manila/manila.conf'
  end

  def self.manila_conf
    return @manila_conf if @manila_conf
    @manila_conf = Puppet::Util::IniConfig::File.new
    @manila_conf.read(conf_filename)
    @manila_conf
  end

  def self.request(service, action, properties=nil)
    begin
      super
    rescue Puppet::Error::OpenstackAuthInputError, Puppet::Error::OpenstackUnauthorizedError => error
      manila_request(service, action, error, properties)
    end
  end

  def self.manila_request(service, action, error, properties=nil)
    properties ||= []
    @credentials.username = manila_credentials['username']
    @credentials.password = manila_credentials['password']
    @credentials.project_name = manila_credentials['project_name']
    @credentials.auth_url = auth_endpoint
    @credentials.user_domain_name = manila_credentials['user_domain_name']
    @credentials.project_domain_name = manila_credentials['project_domain_name']
    if manila_credentials['region_name']
      @credentials.region_name = manila_credentials['region_name']
    end
    raise error unless @credentials.set?
    Puppet::Provider::Openstack.request(service, action, properties, @credentials)
  end

  def self.manila_credentials
    @manila_credentials ||= get_manila_credentials
  end

  def manila_credentials
    self.class.manila_credentials
  end

  def self.get_manila_credentials
    auth_keys = ['auth_url', 'project_name', 'username',
                 'password']
    conf = manila_conf
    if conf and conf['keystone_authtoken'] and
        auth_keys.all?{|k| !conf['keystone_authtoken'][k].nil?}
      creds = Hash[ auth_keys.map \
                   { |k| [k, conf['keystone_authtoken'][k].strip] } ]
      if conf['keystone_authtoken']['project_domain_name']
        creds['project_domain_name'] = conf['keystone_authtoken']['project_domain_name']
      else
        creds['project_domain_name'] = 'Default'
      end

      if conf['keystone_authtoken']['user_domain_name']
        creds['user_domain_name'] = conf['keystone_authtoken']['user_domain_name']
      else
        creds['user_domain_name'] = 'Default'
      end

      if conf['keystone_authtoken']['region_name']
        creds['region_name'] = conf['keystone_authtoken']['region_name']
      end

      return creds
    else
      raise(Puppet::Error, "File: #{conf_filename} does not contain all " +
            "required sections. Manila types will not work if manila is not " +
            "correctly configured.")
    end
  end

  def self.get_auth_endpoint
    q = manila_credentials
    "#{q['auth_url']}"
  end

  def self.auth_endpoint
    @auth_endpoint ||= get_auth_endpoint
  end

  def self.reset
    @manila_conf = nil
    @manila_credentials = nil
    @auth_endpoint = nil
  end
end
