require 'spec_helper'

describe 'manila::setup_test_volume' do
  shared_examples 'manila::setup_test_volume' do
    it { is_expected.to contain_package('lvm2').with(
      :ensure => 'installed',
      :tag    => 'manila-support-package'
    )}

    it {
      is_expected.to contain_exec('create_/var/lib/manila/lvm-shares').with(
        :command => 'dd if=/dev/zero of="/var/lib/manila/lvm-shares" bs=1 count=0 seek=4G',
        :path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
        :unless  => 'stat /var/lib/manila/lvm-shares',
      )
      is_expected.to contain_exec('losetup /dev/loop2 /var/lib/manila/lvm-shares').with(
        :command     => 'losetup /dev/loop2 /var/lib/manila/lvm-shares && udevadm settle',
        :path        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
        :unless      => 'losetup /dev/loop2',
      )
      is_expected.to contain_exec('pvcreate /dev/loop2').with(
        :path        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
        :unless      => 'pvs /dev/loop2',
        :refreshonly => true,
      )
      is_expected.to contain_exec('vgcreate lvm-shares /dev/loop2').with(
        :path        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
        :unless      => 'vgs lvm-shares',
        :refreshonly => true,
      )
    }

    it { is_expected.to contain_file('/var/lib/manila/lvm-shares').with_mode('0640') }
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'manila::setup_test_volume'
    end
  end
end
