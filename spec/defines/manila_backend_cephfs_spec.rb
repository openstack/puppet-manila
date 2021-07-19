require 'spec_helper'

describe 'manila::backend::cephfs' do

  shared_examples_for 'cephfs driver' do
    let(:title) {'cephfs'}
    let :params do
      {
        :driver_handles_share_servers       => false,
        :share_backend_name                 => 'cephfs',
        :cephfs_conf_path                   => '$state_path/ceph.conf',
        :cephfs_auth_id                     => 'manila',
        :cephfs_cluster_name                => 'ceph',
        :cephfs_protocol_helper_type        => 'NFS',
        :cephfs_ganesha_server_ip           => '10.0.0.1',
        :cephfs_ganesha_export_ips          => '10.0.0.1,1001::1001',
        :cephfs_ganesha_server_is_remote    => true,
        :cephfs_ganesha_server_username     => 'ganeshadmin',
        :cephfs_ganesha_path_to_private_key => '/readable/by/manila.key',
        :cephfs_volume_mode                 => '0775',
      }
    end

    it 'configures cephfs driver' do
      is_expected.to contain_manila_config('cephfs/share_driver').with_value(
        'manila.share.drivers.cephfs.driver.CephFSDriver')
      is_expected.to contain_manila_config('cephfs/share_backend_name').with_value(
        'cephfs')
      is_expected.to contain_manila_config('cephfs/cephfs_conf_path').with_value(
        '$state_path/ceph.conf')
      is_expected.to contain_manila_config('cephfs/cephfs_auth_id').with_value(
        'manila')
      is_expected.to contain_manila_config('cephfs/cephfs_cluster_name').with_value(
        'ceph')
      is_expected.to contain_manila_config('cephfs/cephfs_protocol_helper_type').with_value(
        'NFS')
      is_expected.to contain_manila_config('cephfs/cephfs_ganesha_server_ip').with_value(
                       '10.0.0.1')
      is_expected.to contain_manila_config('cephfs/cephfs_ganesha_export_ips').with_value(
                       '10.0.0.1,1001::1001')
      is_expected.to contain_manila_config('cephfs/cephfs_volume_mode').with_value(
        '0775')
      is_expected.to contain_manila_config('cephfs/cephfs_ganesha_server_is_remote').with_value(
        true)
      is_expected.to contain_manila_config('cephfs/cephfs_ganesha_server_username').with_value(
        'ganeshadmin')
      is_expected.to contain_manila_config('cephfs/cephfs_ganesha_path_to_private_key').with_value(
        '/readable/by/manila.key'
      )
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
      }).each do |os,facts|
        context "on #{os}" do
          let (:facts) do
            facts.merge(OSDefaults.get_facts({ :osfamily => "#{os}" }))
          end

          it_configures 'cephfs driver'
        end
      end

end
