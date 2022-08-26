require 'spec_helper'

describe 'manila::backend::glusternfs' do

  shared_examples_for 'glusternfs volume driver' do
    let(:title) {'gnfs'}

    let :params do
      {
        :glusterfs_target              => 'remoteuser@volserver:volid',
        :glusterfs_mount_point_base    => '$state_path/mnt',
        :glusterfs_nfs_server_type     => 'gluster',
        :glusterfs_path_to_private_key => '/etc/glusterfs/glusterfs.pem',
        :glusterfs_ganesha_server_ip   => '127.0.0.1',
        :backend_availability_zone     => 'my_zone',
      }
    end

    describe 'glusternfs share driver' do
      it 'configures gluster nfs/ganesha share driver' do
        is_expected.to contain_manila_config('gnfs/share_backend_name').with(
          :value => 'gnfs')
        is_expected.to contain_manila_config('gnfs/share_driver').with_value(
          'manila.share.drivers.glusterfs.GlusterfsShareDriver')
        params.each_pair do |config,value|
          is_expected.to contain_manila_config("gnfs/#{config}").with_value( value )
        end
      end

      it 'installs gluster packages' do
        is_expected.to contain_package(platform_params[:gluster_package_name]).with(
          'ensure' => 'present',
          'tag'    => 'manila-support-package',
        )
        is_expected.to contain_package(platform_params[:gluster_client_package_name]).with(
          'ensure' => 'present',
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
        case facts[:osfamily]
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

      it_behaves_like 'glusternfs volume driver'
    end
  end
end
