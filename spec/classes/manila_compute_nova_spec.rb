require 'spec_helper'

describe 'manila::compute::nova' do
  shared_examples 'manila::nova' do
    context 'with default parameters' do
      it 'configures manila compute nova' do
        is_expected.to contain_manila_config('nova/insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('nova/auth_url').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('nova/auth_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('nova/cafile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('nova/region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('nova/endpoint_type').with_value('<SERVICE DEFAULT>')

        # These should be added only when auth_type is 'password'
        is_expected.not_to contain_manila_config('nova/user_domain_name')
        is_expected.not_to contain_manila_config('nova/project_domain_name')
        is_expected.not_to contain_manila_config('nova/project_name')
        is_expected.not_to contain_manila_config('nova/username')
        is_expected.not_to contain_manila_config('nova/password')
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :insecure       => true,
          :auth_url       => 'http://127.0.0.2:5000/',
          :auth_type      => 'password',
          :cafile         => '/etc/ssl/certs/ca.crt',
          :region_name    => 'RegionOne',
          :endpoint_type  => 'publicURL',
          :username       => 'novav1',
          :password       => '123123',
        }
      end

      it 'configures manila nova with overridden parameters' do
        is_expected.to contain_manila_config('nova/insecure').with_value(true)
        is_expected.to contain_manila_config('nova/auth_url').with_value('http://127.0.0.2:5000/')
        is_expected.to contain_manila_config('nova/auth_type').with_value('password')
        is_expected.to contain_manila_config('nova/cafile').with_value('/etc/ssl/certs/ca.crt')
        is_expected.to contain_manila_config('nova/user_domain_name').with_value('Default')
        is_expected.to contain_manila_config('nova/project_domain_name').with_value('Default')
        is_expected.to contain_manila_config('nova/project_name').with_value('service')
        is_expected.to contain_manila_config('nova/region_name').with_value('RegionOne')
        is_expected.to contain_manila_config('nova/endpoint_type').with_value('publicURL')
        is_expected.to contain_manila_config('nova/username').with_value('novav1')
        is_expected.to contain_manila_config('nova/password').with_value('123123').with_secret(true)
       end
    end

    context 'with deprecated parameters' do
      let :params do
        {
          :nova_api_insecure             => true,
          :nova_ca_certificates_file     => '/foo/ssl/certs/ca.crt',
          :auth_type                     => 'password',
          :nova_admin_tenant_name        => 'service2',
          :nova_admin_username           => 'novav2',
          :nova_admin_password           => '321321',
        }
      end

      it 'configures manila compute nova with deprecated parameters' do
        is_expected.to contain_manila_config('nova/auth_type').with_value('password')
        is_expected.to contain_manila_config('nova/insecure').with_value(true)
        is_expected.to contain_manila_config('nova/cafile').with_value('/foo/ssl/certs/ca.crt')
        is_expected.to contain_manila_config('nova/project_name').with_value('service2')
        is_expected.to contain_manila_config('nova/username').with_value('novav2')
        is_expected.to contain_manila_config('nova/password').with_value('321321')
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

      it_behaves_like 'manila::nova'
    end
  end
end
