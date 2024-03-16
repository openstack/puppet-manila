require 'spec_helper'

describe 'manila::backend::glusternative' do

  shared_examples_for 'glusternative volume driver' do
    let(:title) {'fuse'}

    let :params do
      {
        :glusterfs_servers                       => 'remoteuser@volserver',
        :glusterfs_path_to_private_key           => '/etc/glusterfs/glusterfs.pem',
        :glusterfs_volume_pattern                => 'manila-share-volume-\d+$',
        :backend_availability_zone               => 'my_zone',
        :reserved_share_percentage               => 10.0,
        :reserved_share_from_snapshot_percentage => 10.1,
        :reserved_share_extend_percentage        => 10.2,
      }
    end

    describe 'glusternative share driver' do
      it 'configures glusterfs fuse/native share driver' do
        is_expected.to contain_manila_config('fuse/share_backend_name').with(
          :value => 'fuse')
        is_expected.to contain_manila_config('fuse/share_driver').with_value(
          'manila.share.drivers.glusterfs_native.GlusterfsNativeShareDriver')
        params.each_pair do |config,value|
          is_expected.to contain_manila_config("fuse/#{config}").with_value( value )
        end
      end

      it 'installs gluster packages' do
        is_expected.to contain_package(platform_params[:gluster_package_name]).with(
          'ensure' => 'installed',
          'tag'    => 'manila-support-package',
        )
        is_expected.to contain_package(platform_params[:gluster_client_package_name]).with(
          'ensure' => 'installed',
          'tag'    => 'manila-support-package',
        )
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
          {
            :gluster_client_package_name => 'glusterfs-client',
            :gluster_package_name        => 'glusterfs-common'
          }
        when 'RedHat'
          {
            :gluster_client_package_name => 'glusterfs-fuse',
            :gluster_package_name        => 'glusterfs'
          }
        end
      end

      it_behaves_like 'glusternative volume driver'
    end
  end

end
