require 'spec_helper'

describe 'manila::backend::cephfsnative' do

  shared_examples_for 'cephfsnative driver' do
    let(:title) {'cephfsnative'}
    let :params do
      {
        :driver_handles_share_servers => false,
        :share_backend_name           => 'cephfs',
        :cephfs_conf_path             => '$state_path/ceph.conf',
        :cephfs_auth_id               => 'manila',
        :cephfs_cluster_name          => 'ceph',
        :cephfs_enable_snapshots      => true,
      }
    end

    it 'configures cephfsnative driver' do
      is_expected.to contain_manila_config('cephfsnative/share_driver').with_value(
        'manila.share.drivers.cephfs.cephfs_native.CephFSNativeDriver')
      is_expected.to contain_manila_config('cephfsnative/share_backend_name').with_value(
        'cephfs')
      is_expected.to contain_manila_config('cephfsnative/cephfs_conf_path').with_value(
        '$state_path/ceph.conf')
      is_expected.to contain_manila_config('cephfsnative/cephfs_auth_id').with_value(
        'manila')
      is_expected.to contain_manila_config('cephfsnative/cephfs_cluster_name').with_value(
        'ceph')
      is_expected.to contain_manila_config('cephfsnative/cephfs_enable_snapshots').with_value(
        true)
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
      }).each do |os,facts|
        context "on #{os}" do
          let (:facts) do
            facts.merge(OSDefaults.get_facts({ :osfamily => "#{os}" }))
          end

          it_configures 'cephfsnative driver'
        end
      end

end
