#
# Unit tests for manila::keystone::auth
#

require 'spec_helper'

describe 'manila::keystone::auth' do
  shared_examples_for 'manila::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'manila_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('manila').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :configure_service   => true,
        :service_name        => 'manila',
        :service_type        => 'shared-file-system',
        :service_description => 'Manila Service',
        :region              => 'RegionOne',
        :auth_name           => 'manila',
        :password            => 'manila_password',
        :email               => 'manila@localhost',
        :tenant              => 'services',
        :roles               => ['admin', 'service'],
        :system_scope        => 'all',
        :system_roles        => [],
        :public_url          => 'http://127.0.0.1:8786/v2',
        :internal_url        => 'http://127.0.0.1:8786/v2',
        :admin_url           => 'http://127.0.0.1:8786/v2',
      ) }

      it { is_expected.to contain_keystone__resource__service_identity('manilav2').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => true,
        :configure_service   => true,
        :service_name        => 'manilav2',
        :service_type        => 'sharev2',
        :service_description => 'Manila Service v2',
        :region              => 'RegionOne',
        :public_url          => 'http://127.0.0.1:8786/v2',
        :internal_url        => 'http://127.0.0.1:8786/v2',
        :admin_url           => 'http://127.0.0.1:8786/v2',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password               => 'manila_password',
          :auth_name              => 'alt_manila',
          :email                  => 'alt_manila@alt_localhost',
          :tenant                 => 'alt_service',
          :roles                  => ['admin'],
          :system_scope           => 'alt_all',
          :system_roles           => ['admin', 'member', 'reader'],
          :configure_endpoint     => false,
          :configure_user         => false,
          :configure_user_role    => false,
          :configure_service      => false,
          :service_description    => 'Alternative Manila Service',
          :service_name           => 'alt_service',
          :service_type           => 'alt_share',
          :region                 => 'RegionTwo',
          :configure_endpoint_v2  => false,
          :configure_service_v2   => false,
          :service_description_v2 => 'Alternative Manila Service v2',
          :service_name_v2        => 'alt_servicev2',
          :service_type_v2        => 'alt_sharev2',
          :public_url_v2          => 'https://10.10.10.10:80',
          :internal_url_v2        => 'http://10.10.10.11:81',
          :admin_url_v2           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('manila').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :configure_service   => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_share',
        :service_description => 'Alternative Manila Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_manila',
        :password            => 'manila_password',
        :email               => 'alt_manila@alt_localhost',
        :tenant              => 'alt_service',
        :roles               => ['admin'],
        :system_scope        => 'alt_all',
        :system_roles        => ['admin', 'member', 'reader'],
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }

      it { is_expected.to contain_keystone__resource__service_identity('manilav2').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :configure_service   => false,
        :service_name        => 'alt_servicev2',
        :service_type        => 'alt_sharev2',
        :service_description => 'Alternative Manila Service v2',
        :region              => 'RegionTwo',
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'manila::keystone::auth'
    end
  end
end
