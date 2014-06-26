require 'spec_helper'

describe 'manila::setup_test_share' do

  it { should contain_package('lvm2').with(
        :ensure => 'present'
      ) }

  it 'should contain share creation execs' do
    should contain_exec('/bin/dd if=/dev/zero of=manila-shares bs=1 count=0 seek=4G')
    should contain_exec('/sbin/losetup /dev/loop2 manila-shares')
    should contain_exec('/sbin/pvcreate /dev/loop2')
    should contain_exec('/sbin/vgcreate manila-shares /dev/loop2')
  end
end
