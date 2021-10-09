require 'spec_helper'

describe 'manila::network::neutron' do
  shared_examples 'manila::neutron' do
    context 'with default parameters' do
      it 'configures manila network neutron' do
        is_expected.to contain_manila_config('neutron/insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('neutron/auth_url').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('neutron/auth_type').with_value('password')
        is_expected.to contain_manila_config('neutron/cafile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('neutron/user_domain_name').with_value('Default')
        is_expected.to contain_manila_config('neutron/project_domain_name').with_value('Default')
        is_expected.to contain_manila_config('neutron/project_name').with_value('services')
        is_expected.to contain_manila_config('neutron/region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('neutron/timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('neutron/endpoint_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('neutron/username').with_value('neutron')
        is_expected.to contain_manila_config('neutron/password').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/network_plugin_ipv4_enabled').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/network_plugin_ipv6_enabled').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :insecure       => true,
          :auth_url       => 'http://127.0.0.2:5000/',
          :auth_type      => 'v3password',
          :cafile         => '/etc/ssl/certs/ca.crt',
          :region_name    => 'RegionOne',
          :timeout        => 30,
          :endpoint_type  => 'publicURL',
          :username       => 'neutronv1',
          :password       => '123123',
          :network_plugin_ipv4_enabled  => false,
          :network_plugin_ipv6_enabled  => true,
        }
      end

      it 'configures manila neutron with overridden parameters' do
      	is_expected.to contain_manila_config('DEFAULT/network_api_class').with_value('manila.network.neutron.neutron_network_plugin.NeutronNetworkPlugin')
        is_expected.to contain_manila_config('neutron/insecure').with_value(true)
        is_expected.to contain_manila_config('neutron/auth_url').with_value('http://127.0.0.2:5000/')
        is_expected.to contain_manila_config('neutron/auth_type').with_value('v3password')
        is_expected.to contain_manila_config('neutron/cafile').with_value('/etc/ssl/certs/ca.crt')
        is_expected.to contain_manila_config('neutron/user_domain_name').with_value('Default')
        is_expected.to contain_manila_config('neutron/project_domain_name').with_value('Default')
        is_expected.to contain_manila_config('neutron/project_name').with_value('services')
        is_expected.to contain_manila_config('neutron/region_name').with_value('RegionOne')
        is_expected.to contain_manila_config('neutron/timeout').with_value(30)
        is_expected.to contain_manila_config('neutron/endpoint_type').with_value('publicURL')
        is_expected.to contain_manila_config('neutron/username').with_value('neutronv1')
        is_expected.to contain_manila_config('neutron/password').with_value('123123').with_secret(true)
        is_expected.to contain_manila_config('DEFAULT/network_plugin_ipv4_enabled').with_value(false)
        is_expected.to contain_manila_config('DEFAULT/network_plugin_ipv6_enabled').with_value(true)
       end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :fqdn => 'some.host.tld'}))
      end

      it_behaves_like 'manila::neutron'
    end
  end
end
