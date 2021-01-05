require 'spec_helper'

describe 'manila::volume::cinder' do
  shared_examples 'manila::volume::cinder' do
    context 'with default parameters' do
      it 'configures manila volume cinder' do
        is_expected.to contain_manila_config('cinder/insecure').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('cinder/auth_url').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('cinder/auth_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('cinder/cafile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('cinder/region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('cinder/endpoint_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('cinder/user_domain_name').with_value('Default')
        is_expected.to contain_manila_config('cinder/project_domain_name').with_value('Default')
        is_expected.to contain_manila_config('cinder/project_name').with_value('services')
        is_expected.to contain_manila_config('cinder/username').with_value('cinder')
        is_expected.to contain_manila_config('cinder/password').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('cinder/http_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('cinder/cross_az_attach').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :insecure        => true,
          :auth_url        => 'http://127.0.0.2:5000/',
          :auth_type       => 'password',
          :cafile          => '/etc/ssl/certs/ca.crt',
          :region_name     => 'RegionOne',
          :endpoint_type   => 'publicURL',
          :username        => 'cinderv1',
          :password        => '123123',
          :http_retries    => 3,
          :cross_az_attach => true,
        }
      end

      it 'configures manila cinder with overridden parameters' do
        is_expected.to contain_manila_config('cinder/insecure').with_value(true)
        is_expected.to contain_manila_config('cinder/auth_url').with_value('http://127.0.0.2:5000/')
        is_expected.to contain_manila_config('cinder/auth_type').with_value('password')
        is_expected.to contain_manila_config('cinder/cafile').with_value('/etc/ssl/certs/ca.crt')
        is_expected.to contain_manila_config('cinder/user_domain_name').with_value('Default')
        is_expected.to contain_manila_config('cinder/project_domain_name').with_value('Default')
        is_expected.to contain_manila_config('cinder/project_name').with_value('services')
        is_expected.to contain_manila_config('cinder/region_name').with_value('RegionOne')
        is_expected.to contain_manila_config('cinder/endpoint_type').with_value('publicURL')
        is_expected.to contain_manila_config('cinder/username').with_value('cinderv1')
        is_expected.to contain_manila_config('cinder/password').with_value('123123').with_secret(true)
        is_expected.to contain_manila_config('cinder/http_retries').with_value(3)
        is_expected.to contain_manila_config('cinder/cross_az_attach').with_value('true')
       end
    end

    context 'with deprecated parameters' do
      let :params do
        {
          :cinder_api_insecure           => true,
          :cinder_ca_certificates_file   => '/foo/ssl/certs/ca.crt',
          :auth_type                     => 'password',
          :cinder_admin_tenant_name      => 'service2',
          :cinder_admin_username         => 'cinderv2',
          :cinder_admin_password         => '321321',
          :cinder_http_retries           => 3,
          :cinder_cross_az_attach        => true,
        }
      end

      it 'configures manila volume cinder with deprecated parameters' do
        is_expected.to contain_manila_config('cinder/auth_type').with_value('password')
        is_expected.to contain_manila_config('cinder/insecure').with_value(true)
        is_expected.to contain_manila_config('cinder/cafile').with_value('/foo/ssl/certs/ca.crt')
        is_expected.to contain_manila_config('cinder/project_name').with_value('service2')
        is_expected.to contain_manila_config('cinder/username').with_value('cinderv2')
        is_expected.to contain_manila_config('cinder/password').with_value('321321')
        is_expected.to contain_manila_config('cinder/http_retries').with_value(3)
        is_expected.to contain_manila_config('cinder/cross_az_attach').with_value('true')
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

      it_behaves_like 'manila::volume::cinder'
    end
  end
end
