require 'spec_helper'

describe 'manila::backend::glusterfs' do

  shared_examples_for 'glusterfs volume driver' do
    let(:title) {'mygluster'}

    let :params do
      {
        :glusterfs_shares           => ['10.10.10.10:/volumes', '10.10.10.11:/volumes'],
        :glusterfs_shares_config    => '/etc/manila/other_shares.conf',
        :glusterfs_sparsed_volumes  => true,
        :glusterfs_mount_point_base => '/manila_mount_point',
      }
    end

    it 'configures glusterfs volume driver' do
      should contain_manila_config('mygluster/volume_driver').with_value(
        'manila.volume.drivers.glusterfs.GlusterfsDriver')
      should contain_manila_config('mygluster/glusterfs_shares_config').with_value(
        '/etc/manila/other_shares.conf')
      should contain_manila_config('mygluster/glusterfs_sparsed_volumes').with_value(
        true)
      should contain_manila_config('mygluster/glusterfs_mount_point_base').with_value(
        '/manila_mount_point')
      should contain_file('/etc/manila/other_shares.conf').with(
        :content => "10.10.10.10:/volumes\n10.10.10.11:/volumes\n",
        :require => 'Package[manila]',
        :notify  => 'Service[manila-volume]'
      )
    end

    context "with an parameter which has been removed" do
      before do
        params.merge!({
          :glusterfs_disk_util => 'foo',
        })
      end
      it 'should fails' do
        expect { subject }.to raise_error(Puppet::Error, /glusterfs_disk_util is removed in Icehouse./)
      end
    end
  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    it_configures 'glusterfs volume driver'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it_configures 'glusterfs volume driver'
  end

end
