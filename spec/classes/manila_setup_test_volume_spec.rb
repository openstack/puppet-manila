require 'spec_helper'

describe 'manila::setup_test_volume' do

  it { should contain_package('lvm2').with(
        :ensure => 'present'
      ) }

  it 'should contain volume creation execs' do
    should contain_exec('/bin/dd if=/dev/zero of=manila-volumes bs=1 count=0 seek=4G')
    should contain_exec('/sbin/losetup /dev/loop2 manila-volumes')
    should contain_exec('/sbin/pvcreate /dev/loop2')
    should contain_exec('/sbin/vgcreate manila-volumes /dev/loop2')
  end
end
