require 'spec_helper'

describe 'manila::data' do

  shared_examples_for 'manila::data' do

    context 'with default parameters' do

      it { is_expected.to contain_class('manila::params') }

      it 'should configure manila-data options' do
        is_expected.to contain_manila_config('DEFAULT/mount_tmp_location').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/backup_mount_tmp_location').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/check_hash').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/backup_continue_update_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/restore_continue_update_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/backup_driver').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/backup_share_mount_template').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/backup_share_unmount_template').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/backup_ignore_files').with_value('<SERVICE DEFAULT>')
      end

      it { is_expected.to contain_service('manila-data').with(
        :name      => platform_params[:data_service],
        :enable    => true,
        :ensure    => 'running',
        :hasstatus => true,
        :tag       => 'manila-service',
      ) }
    end

    context 'with parameters' do
      let :params do
        {
          :mount_tmp_location               => '/tmp/',
          :backup_mount_tmp_location        => '/tmp/backup/',
          :check_hash                       => false,
          :backup_continue_update_interval  => 10,
          :restore_continue_update_interval => 11,
          :backup_driver                    => 'manila.data.drivers.nfs.NFSBackupDriver',
          :backup_share_mount_template      => 'mount -vt %(proto)s %(options)s %(export)s %(path)s',
          :backup_share_unmount_template    => 'umount -v %(path)s',
          :backup_ignore_files              => ['lost+found'],
        }
      end

      it 'should configure manila-data options' do
        is_expected.to contain_manila_config('DEFAULT/mount_tmp_location').with_value('/tmp/')
        is_expected.to contain_manila_config('DEFAULT/backup_mount_tmp_location').with_value('/tmp/backup/')
        is_expected.to contain_manila_config('DEFAULT/check_hash').with_value(false)
        is_expected.to contain_manila_config('DEFAULT/backup_continue_update_interval').with_value(10)
        is_expected.to contain_manila_config('DEFAULT/restore_continue_update_interval').with_value(11)
        is_expected.to contain_manila_config('DEFAULT/backup_driver').with_value('manila.data.drivers.nfs.NFSBackupDriver')
        is_expected.to contain_manila_config('DEFAULT/backup_share_mount_template').with_value('mount -vt %(proto)s %(options)s %(export)s %(path)s')
        is_expected.to contain_manila_config('DEFAULT/backup_share_unmount_template').with_value('umount -v %(path)s')
        is_expected.to contain_manila_config('DEFAULT/backup_ignore_files').with_value('lost+found')
      end
    end

    context 'with manage_service false' do
      let :params do
        {
          :manage_service => false
        }
      end
      it 'should not configure the service' do
        is_expected.to_not contain_service('manila-data')
      end
    end
  end

  shared_examples_for 'manila::data on Debian' do
    context 'with default parameters' do
      it { is_expected.to contain_package('manila-data').with(
        :name      => 'manila-data',
        :ensure    => 'present',
        :tag       => ['openstack', 'manila-package'],
      ) }
    end

    context 'with parameters' do
      let :params do
        {
          :package_ensure => 'installed'
        }
      end

      it { is_expected.to contain_package('manila-data').with(
        :name      => 'manila-data',
        :ensure    => 'installed',
        :tag       => ['openstack', 'manila-package'],
      ) }
    end
  end

  shared_examples_for 'manila::data on RedHat' do
    context 'with default parameters' do
      it { is_expected.to_not contain_package('manila-data') }
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
          { :data_service => 'manila-data' }
        when 'RedHat'
          { :data_service => 'openstack-manila-data' }
        end
      end

      it_behaves_like 'manila::data'
      it_behaves_like "manila::data on #{facts[:os]['family']}"
    end
  end

end
