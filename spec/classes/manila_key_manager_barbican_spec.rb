require 'spec_helper'

describe 'manila::key_manager::barbican' do
  shared_examples 'manila::key_manager::barbican' do
    context 'with default parameters' do
      let :params do
        { :password => 'manilapassword' }
      end

      it {
        is_expected.to contain_oslo__key_manager__barbican('manila_config').with(
          :barbican_endpoint      => '<SERVICE DEFAULT>',
          :barbican_api_version   => '<SERVICE DEFAULT>',
          :auth_endpoint          => '<SERVICE DEFAULT>',
          :barbican_endpoint_type => '<SERVICE DEFAULT>',
          :barbican_region_name   => '<SERVICE DEFAULT>',
        )

        is_expected.to contain_manila_config('barbican/username').with_value('manila')
        is_expected.to contain_manila_config('barbican/password').with_value('manilapassword').with_secret(true)
        is_expected.to contain_manila_config('barbican/auth_url').with_value('http://localhost:5000')
        is_expected.to contain_manila_config('barbican/project_name').with_value('services')
        is_expected.to contain_manila_config('barbican/user_domain_name').with_value('Default')
        is_expected.to contain_manila_config('barbican/project_domain_name').with_value('Default')
        is_expected.to contain_manila_config('barbican/system_scope').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('barbican/region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('barbican/endpoint_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('barbican/insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('barbican/auth_type').with_value('password')
        is_expected.to contain_manila_config('barbican/cafile').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'with specified parameters' do
      let :params do
        {
          :barbican_endpoint      => 'http://localhost:9311/',
          :barbican_api_version   => 'v1',
          :auth_endpoint          => 'http://localhost:5000',
          :barbican_endpoint_type => 'public',
          :barbican_region_name   => 'regionOne',
          :auth_url               => 'http://127.0.0.1:5000',
          :username               => 'alt_manila',
          :password               => 'manilapassword',
          :project_name           => 'alt_services',
          :user_domain_name       => 'UserDomain',
          :project_domain_name    => 'ProjectDomain',
          :region_name            => 'regionOne',
          :endpoint_type          => 'publicURL',
          :insecure               => false,
          :auth_type              => 'v3password',
          :cafile                 => 'cafile',
        }
      end

      it {
        is_expected.to contain_oslo__key_manager__barbican('manila_config').with(
          :barbican_endpoint      => 'http://localhost:9311/',
          :barbican_api_version   => 'v1',
          :auth_endpoint          => 'http://localhost:5000',
          :barbican_endpoint_type => 'public',
          :barbican_region_name   => 'regionOne',
        )

        is_expected.to contain_manila_config('barbican/username').with_value('alt_manila')
        is_expected.to contain_manila_config('barbican/password').with_value('manilapassword').with_secret(true)
        is_expected.to contain_manila_config('barbican/auth_url').with_value('http://127.0.0.1:5000')
        is_expected.to contain_manila_config('barbican/project_name').with_value('alt_services')
        is_expected.to contain_manila_config('barbican/user_domain_name').with_value('UserDomain')
        is_expected.to contain_manila_config('barbican/project_domain_name').with_value('ProjectDomain')
        is_expected.to contain_manila_config('barbican/system_scope').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('barbican/region_name').with_value('regionOne')
        is_expected.to contain_manila_config('barbican/endpoint_type').with_value('publicURL')
        is_expected.to contain_manila_config('barbican/insecure').with_value(false)
        is_expected.to contain_manila_config('barbican/auth_type').with_value('v3password')
        is_expected.to contain_manila_config('barbican/cafile').with_value('cafile')
      }
    end

    context 'when system_scope is set' do
      let :params do
        {
          :password     => 'manilapassword',
          :system_scope => 'all'
        }
      end
      it 'configures system-scoped credential' do
        is_expected.to contain_manila_config('barbican/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('barbican/project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('barbican/system_scope').with_value('all')
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'manila::key_manager::barbican'
    end
  end
end
