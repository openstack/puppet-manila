require 'spec_helper'

describe 'manila::share::glusterfs' do

  shared_examples_for 'glusterfs share driver' do
    let :params do
      {
        :glusterfs_shares           => ['10.10.10.10:/shares', '10.10.10.11:/shares'],
        :glusterfs_shares_config    => '/etc/manila/other_shares.conf',
        :glusterfs_sparsed_shares  => true,
        :glusterfs_mount_point_base => '/manila_mount_point',
      }
    end

    it 'configures glusterfs share driver' do
      should contain_manila_config('DEFAULT/share_driver').with_value(
        'manila.share.drivers.glusterfs.GlusterfsDriver')
      should contain_manila_config('DEFAULT/glusterfs_shares_config').with_value(
        '/etc/manila/other_shares.conf')
      should contain_manila_config('DEFAULT/glusterfs_sparsed_shares').with_value(
        true)
      should contain_manila_config('DEFAULT/glusterfs_mount_point_base').with_value(
        '/manila_mount_point')
      should contain_file('/etc/manila/other_shares.conf').with(
        :content => "10.10.10.10:/shares\n10.10.10.11:/shares\n",
        :require => 'Package[manila]',
        :notify  => 'Service[manila-share]'
      )
    end

  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    it_configures 'glusterfs share driver'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it_configures 'glusterfs share driver'
  end

end
