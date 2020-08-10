require 'spec_helper'

describe 'manila::backend::glusternative' do

  shared_examples_for 'glusternative volume driver' do
    let(:title) {'fuse'}

    let :params do
      {
        :glusterfs_servers                    => 'remoteuser@volserver',
        :glusterfs_path_to_private_key        => '/etc/glusterfs/glusterfs.pem',
        :glusterfs_volume_pattern             => 'manila-share-volume-\d+$',
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
    end


    context 'with deprecated parameters' do
      let :params do
        {
          :glusterfs_servers                    => 'remoteuser@volserver',
          :glusterfs_native_path_to_private_key => '/etc/glusterfs/glusterfs.pem',
          :glusterfs_volume_pattern             => 'manila-share-volume-\d+$',
        }
      end

      it 'configures glusternative share driver with deprecated parameters' do
        is_expected.to contain_manila_config('fuse/share_backend_name').with(
          :value => 'fuse')
        is_expected.to contain_manila_config('fuse/share_driver').with_value(
          'manila.share.drivers.glusterfs_native.GlusterfsNativeShareDriver')
        is_expected.to contain_manila_config('fuse/glusterfs_servers').with_value(
          'remoteuser@volserver')
        is_expected.to contain_manila_config('fuse/glusterfs_path_to_private_key').with_value(
          '/etc/glusterfs/glusterfs.pem')
        is_expected.to contain_manila_config('fuse/glusterfs_volume_pattern').with_value(
          'manila-share-volume-\d+$')
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

      it_behaves_like 'glusternative volume driver'
    end
  end

end
