require 'spec_helper'

describe 'manila::share' do

  shared_examples_for 'manila-share' do
    context 'with default parameters' do
      it { is_expected.to contain_package('manila-share').with(
        :name   => platform_params[:package_name],
        :ensure => 'present',
        :tag    => ['openstack', 'manila-package'],
      ) }
      it { is_expected.to contain_service('manila-share').with(
        'hasstatus' => true,
        'tag'       => 'manila-service',
      )}

      it 'should configure share options' do
        is_expected.to contain_manila_config('DEFAULT/delete_share_server_with_last_share').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/unmanage_remove_access_rules').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/automatic_share_server_cleanup').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/unused_share_server_cleanup_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/replica_state_update_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/migration_driver_continue_update_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/server_migration_driver_continue_update_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/share_usage_size_update_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/enable_gathering_share_usage_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/share_service_inithost_offload').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/check_for_expired_shares_in_recycle_bin_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/check_for_expired_transfers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/driver_backup_continue_update_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/driver_restore_continue_update_interval').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters' do
      let :params do
        {
          :delete_share_server_with_last_share              => false,
          :unmanage_remove_access_rules                     => false,
          :automatic_share_server_cleanup                   => true,
          :unused_share_server_cleanup_interval             => 10,
          :replica_state_update_interval                    => 300,
          :migration_driver_continue_update_interval        => 60,
          :server_migration_driver_continue_update_interval => 900,
          :share_usage_size_update_interval                 => 300,
          :enable_gathering_share_usage_size                => false,
          :share_service_inithost_offload                   => false,
          :check_for_expired_shares_in_recycle_bin_interval => 3600,
          :check_for_expired_transfers                      => 300,
          :driver_backup_continue_update_interval           => 60,
          :driver_restore_continue_update_interval          => 60,
        }
      end

      it 'should configure share options' do
        is_expected.to contain_manila_config('DEFAULT/delete_share_server_with_last_share').with_value(false)
        is_expected.to contain_manila_config('DEFAULT/unmanage_remove_access_rules').with_value(false)
        is_expected.to contain_manila_config('DEFAULT/automatic_share_server_cleanup').with_value(true)
        is_expected.to contain_manila_config('DEFAULT/unused_share_server_cleanup_interval').with_value(10)
        is_expected.to contain_manila_config('DEFAULT/replica_state_update_interval').with_value(300)
        is_expected.to contain_manila_config('DEFAULT/migration_driver_continue_update_interval').with_value(60)
        is_expected.to contain_manila_config('DEFAULT/server_migration_driver_continue_update_interval').with_value(900)
        is_expected.to contain_manila_config('DEFAULT/share_usage_size_update_interval').with_value(300)
        is_expected.to contain_manila_config('DEFAULT/enable_gathering_share_usage_size').with_value(false)
        is_expected.to contain_manila_config('DEFAULT/share_service_inithost_offload').with_value(false)
        is_expected.to contain_manila_config('DEFAULT/check_for_expired_shares_in_recycle_bin_interval').with_value(3600)
        is_expected.to contain_manila_config('DEFAULT/check_for_expired_transfers').with_value(300)
        is_expected.to contain_manila_config('DEFAULT/driver_backup_continue_update_interval').with_value(60)
        is_expected.to contain_manila_config('DEFAULT/driver_restore_continue_update_interval').with_value(60)
      end
    end

    context 'with manage_service false' do
      let :params do
        { 'manage_service' => false }
      end
      it 'should not configure the service' do
        is_expected.to_not contain_service('manila-share')
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

      let :platform_params do
        case facts[:os]['family']
        when 'Debian'
          { :package_name => 'manila-share' }
        when 'RedHat'
          { :package_name => 'openstack-manila-share' }
        end
      end

      it_behaves_like 'manila-share'
    end
  end
end
