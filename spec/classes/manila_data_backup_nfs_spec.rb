require 'spec_helper'

describe 'manila::data::backup::nfs' do

  shared_examples_for 'manila::data::backup::nfs' do

    let :params do
      {
        :backup_mount_export => '192.0.2.1:/backup',
      }
    end

    context 'with default parameters' do

      it 'should configure manila-data options' do
        is_expected.to contain_manila_config('DEFAULT/backup_mount_template').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/backup_unmount_template').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/backup_mount_export').with_value('192.0.2.1:/backup')
        is_expected.to contain_manila_config('DEFAULT/backup_mount_proto').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/backup_mount_options').with_value('<SERVICE DEFAULT>')
      end

    end

    context 'with parameters' do
      before :each do
        params.merge!({
          :backup_mount_template   => 'mount -vt %(proto)s %(options)s %(export)s %(path)s',
          :backup_unmount_template => 'umount -v %(path)s',
          :backup_mount_proto      => 'nfs',
          :backup_mount_options    => '',
        })
      end

      it 'should configure manila-data options' do
        is_expected.to contain_manila_config('DEFAULT/backup_mount_template').with_value('mount -vt %(proto)s %(options)s %(export)s %(path)s')
        is_expected.to contain_manila_config('DEFAULT/backup_unmount_template').with_value('umount -v %(path)s')
        is_expected.to contain_manila_config('DEFAULT/backup_mount_proto').with_value('nfs')
        is_expected.to contain_manila_config('DEFAULT/backup_mount_options').with_value('')
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

      it_behaves_like 'manila::data::backup::nfs'
    end
  end

end
