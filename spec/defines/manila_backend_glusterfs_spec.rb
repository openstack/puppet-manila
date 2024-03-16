require 'spec_helper'

describe 'manila::backend::glusterfs' do

  shared_examples_for 'glusterfs share driver' do
    let(:title) {'mygluster'}

    let :params do
      {
        :glusterfs_volumes_config    => '/etc/manila/glusterfs_volumes',
        :glusterfs_mount_point_base  => '$state_path/mnt',
        :backend_availability_zone   => 'my_zone',
      }
    end

    it 'configures glusterfs share driver' do
      is_expected.to contain_manila_config('mygluster/share_backend_name').with_value(
        'mygluster')
      is_expected.to contain_manila_config('mygluster/share_driver').with_value(
        'manila.share.drivers.glusterfs.GlusterfsShareDriver')
      is_expected.to contain_manila_config('mygluster/glusterfs_volumes_config').with_value(
        '/etc/manila/glusterfs_volumes')
      is_expected.to contain_manila_config('mygluster/glusterfs_mount_point_base').with_value(
        '$state_path/mnt')
      is_expected.to contain_manila_config('mygluster/backend_availability_zone').with_value(
        'my_zone')
      is_expected.to contain_manila_config('mygluster/reserved_share_percentage').with_value(
        '<SERVICE DEFAULT>')
      is_expected.to contain_manila_config('mygluster/reserved_share_from_snapshot_percentage').with_value(
        '<SERVICE DEFAULT>')
      is_expected.to contain_manila_config('mygluster/reserved_share_extend_percentage').with_value(
        '<SERVICE DEFAULT>')
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'glusterfs share driver'
    end
  end
end
