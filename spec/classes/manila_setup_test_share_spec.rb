require 'spec_helper'

describe 'manila::setup_test_share' do

  it { should contain_file('/var/lib/manila').with(
        :ensure => 'directory',
        :require => 'Package[manila]'
      ) }

  it 'should contain share creation execs' do
    should contain_exec('create_/var/lib/manila/manila-shares').with(
        :command => 'dd if=/dev/zero of="/var/lib/manila/manila-shares" bs=1 count=0 seek=4G'
      )
    should contain_exec('losetup /dev/loop2 /var/lib/manila/manila-shares')
    should contain_exec('pvcreate /dev/loop2')
    should contain_exec('vgcreate manila-shares /dev/loop2')
  end
end
