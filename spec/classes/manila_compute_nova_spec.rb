require 'spec_helper'

describe 'manila::compute::nova' do

  shared_examples 'manila-nova' do

    context 'with default parameters' do

      it 'configures manila compute nova' do
        is_expected.to contain_manila_config('DEFAULT/nova_catalog_info').with_value('compute:nova:publicURL')
        is_expected.to contain_manila_config('DEFAULT/nova_catalog_admin_info').with_value('compute:nova:adminURL')
        is_expected.to contain_manila_config('DEFAULT/nova_api_insecure').with_value(false)
        is_expected.to contain_manila_config('DEFAULT/nova_admin_username').with_value('nova')
        is_expected.to contain_manila_config('DEFAULT/nova_admin_tenant_name').with_value('service')
        is_expected.to contain_manila_config('DEFAULT/nova_admin_auth_url').with_value('http://localhost:5000/v2.0')
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :nova_catalog_info         => 'compute:nova:internalURL',
          :nova_catalog_admin_info   => 'compute:nova:publicURL',
          :nova_ca_certificates_file => '/etc/ca.cert',
          :nova_api_insecure         => true,
          :nova_admin_username       => 'novav1',
          :nova_admin_password       => '123123',
          :nova_admin_tenant_name    => 'services',
          :nova_admin_auth_url       => 'http://localhost:5000/v3',
        }
      end
      it 'configures manila nova' do
        is_expected.to contain_manila_config('DEFAULT/nova_catalog_info').with_value('compute:nova:internalURL')
        is_expected.to contain_manila_config('DEFAULT/nova_catalog_admin_info').with_value('compute:nova:publicURL')
        is_expected.to contain_manila_config('DEFAULT/nova_ca_certificates_file').with_value('/etc/ca.cert')
        is_expected.to contain_manila_config('DEFAULT/nova_api_insecure').with_value(true)
        is_expected.to contain_manila_config('DEFAULT/nova_admin_username').with_value('novav1')
        is_expected.to contain_manila_config('DEFAULT/nova_admin_tenant_name').with_value('services')
        is_expected.to contain_manila_config('DEFAULT/nova_admin_password').with_value('123123').with_secret(true)
        is_expected.to contain_manila_config('DEFAULT/nova_admin_auth_url').with_value('http://localhost:5000/v3')
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'manila-nova'
    end
  end
end
