require 'spec_helper'

describe 'manila::image::glance' do
  shared_examples 'manila::glance' do
    context 'with default parameters' do
      it 'configures manila image glance' do
        is_expected.to contain_manila_config('glance/api_microversion').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('glance/insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('glance/auth_url').with_value('http://127.0.0.1:5000')
        is_expected.to contain_manila_config('glance/auth_type').with_value('password')
        is_expected.to contain_manila_config('glance/cafile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('glance/certfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('glance/keyfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('glance/user_domain_name').with_value('Default')
        is_expected.to contain_manila_config('glance/project_domain_name').with_value('Default')
        is_expected.to contain_manila_config('glance/project_name').with_value('services')
        is_expected.to contain_manila_config('glance/system_scope').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('glance/region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('glance/timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('glance/endpoint_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('glance/username').with_value('glance')
        is_expected.to contain_manila_config('glance/password').with_value('<SERVICE DEFAULT>').with_secret(true)
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :api_microversion => '2',
          :insecure         => true,
          :auth_url         => 'http://127.0.0.2:5000/',
          :auth_type        => 'v3password',
          :cafile           => '/etc/ssl/certs/ca.crt',
          :region_name      => 'RegionOne',
          :timeout          => 60,
          :endpoint_type    => 'publicURL',
          :username         => 'glancev1',
          :password         => '123123',
        }
      end

      it 'configures manila glance with overridden parameters' do
        is_expected.to contain_manila_config('glance/api_microversion').with_value('2')
        is_expected.to contain_manila_config('glance/insecure').with_value(true)
        is_expected.to contain_manila_config('glance/auth_url').with_value('http://127.0.0.2:5000/')
        is_expected.to contain_manila_config('glance/auth_type').with_value('v3password')
        is_expected.to contain_manila_config('glance/cafile').with_value('/etc/ssl/certs/ca.crt')
        is_expected.to contain_manila_config('glance/certfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('glance/keyfile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('glance/user_domain_name').with_value('Default')
        is_expected.to contain_manila_config('glance/project_domain_name').with_value('Default')
        is_expected.to contain_manila_config('glance/project_name').with_value('services')
        is_expected.to contain_manila_config('glance/system_scope').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('glance/region_name').with_value('RegionOne')
        is_expected.to contain_manila_config('glance/timeout').with_value(60)
        is_expected.to contain_manila_config('glance/endpoint_type').with_value('publicURL')
        is_expected.to contain_manila_config('glance/username').with_value('glancev1')
        is_expected.to contain_manila_config('glance/password').with_value('123123').with_secret(true)
       end
    end

    context 'when system_scope is set' do
      let :params do
        {
          :system_scope => 'all'
        }
      end
      it 'configures system-scoped credential' do
        is_expected.to contain_manila_config('glance/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('glance/project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('glance/system_scope').with_value('all')
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

      it_behaves_like 'manila::glance'
    end
  end
end
