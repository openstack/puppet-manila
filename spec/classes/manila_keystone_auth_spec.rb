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
        :service_name        => 'manila',
        :service_type        => 'share',
        :service_description => 'Manila Service',
        :region              => 'RegionOne',
        :auth_name           => 'manila',
        :password            => 'manila_password',
        :email               => 'manila@localhost',
        :tenant              => 'services',
        :roles               => ['admin'],
        :system_scope        => 'all',
        :system_roles        => [],
        :public_url          => 'http://127.0.0.1:8786/v1/%(tenant_id)s',
        :internal_url        => 'http://127.0.0.1:8786/v1/%(tenant_id)s',
        :admin_url           => 'http://127.0.0.1:8786/v1/%(tenant_id)s',
      ) }

      it { is_expected.to contain_keystone__resource__service_identity('manilav2').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => true,
        :service_name        => 'manilav2',
        :service_type        => 'sharev2',
        :service_description => 'Manila Service v2',
        :region              => 'RegionOne',
        :auth_name           => 'manilav2',
        :password            => 'manila_password',
        :email               => 'manilav2@localhost',
        :tenant              => 'services',
        :roles               => ['admin'],
        :system_scope        => 'all',
        :system_roles        => [],
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
          :roles                  => ['admin', 'service'],
          :system_scope           => 'alt_all',
          :system_roles           => ['admin', 'member', 'reader'],
          :configure_endpoint     => false,
          :configure_user         => false,
          :configure_user_role    => false,
          :service_description    => 'Alternative Manila Service',
          :service_name           => 'alt_service',
          :service_type           => 'alt_share',
          :region                 => 'RegionTwo',
          :public_url             => 'https://10.10.10.10:80',
          :internal_url           => 'http://10.10.10.11:81',
          :admin_url              => 'http://10.10.10.12:81',
          :password_v2            => 'manilav2_password',
          :auth_name_v2           => 'alt_manilav2',
          :email_v2               => 'alt_manilav2@alt_localhost',
          :configure_endpoint_v2  => false,
          :configure_user_v2      => true,
          :configure_user_role_v2 => true,
          :service_description_v2 => 'Alternative Manila Service v2',
          :service_name_v2        => 'alt_servicev2',
          :service_type_v2        => 'alt_sharev2',
          :public_url_v2          => 'https://10.10.10.20:80',
          :internal_url_v2        => 'http://10.10.10.21:81',
          :admin_url_v2           => 'http://10.10.10.22:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('manila').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_share',
        :service_description => 'Alternative Manila Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_manila',
        :password            => 'manila_password',
        :email               => 'alt_manila@alt_localhost',
        :tenant              => 'alt_service',
        :roles               => ['admin', 'service'],
        :system_scope        => 'alt_all',
        :system_roles        => ['admin', 'member', 'reader'],
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }

      it { is_expected.to contain_keystone__resource__service_identity('manilav2').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => false,
        :service_name        => 'alt_servicev2',
        :service_type        => 'alt_sharev2',
        :service_description => 'Alternative Manila Service v2',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_manilav2',
        :password            => 'manilav2_password',
        :email               => 'alt_manilav2@alt_localhost',
        :tenant              => 'alt_service',
        :roles               => ['admin', 'service'],
        :system_scope        => 'alt_all',
        :system_roles        => ['admin', 'member', 'reader'],
        :public_url          => 'https://10.10.10.20:80',
        :internal_url        => 'http://10.10.10.21:81',
        :admin_url           => 'http://10.10.10.22:81',
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
