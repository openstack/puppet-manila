require 'spec_helper'

describe 'manila::backend::lvm' do

  shared_examples_for 'lvm share driver' do
    let(:title) {'mylvm'}

    let :params do
      {
        :lvm_share_export_ips      => '1.2.3.4',
        :lvm_share_export_root     => '$state_path/mnt',
        :lvm_share_mirrors         => 1,
        :lvm_share_volume_group    => 'lvm-shares',
        :lvm_share_helpers         => ['CIFS=manila.share.drivers.helpers.CIFSHelperUserAccess','NFS=manila.share.drivers.helpers.NFSHelper'],
        :backend_availability_zone => 'my_zone',
      }
    end

    it 'configures lvm share driver' do
      is_expected.to contain_manila_config('mylvm/share_backend_name').with_value('mylvm')
      is_expected.to contain_manila_config('mylvm/share_driver').with_value(
        'manila.share.drivers.lvm.LVMShareDriver')
      is_expected.to contain_manila_config('mylvm/driver_handles_share_servers').with_value(false)
      is_expected.to contain_manila_config('mylvm/lvm_share_export_ips').with_value('1.2.3.4')
      is_expected.to contain_manila_config('mylvm/lvm_share_export_root').with_value('$state_path/mnt')
      is_expected.to contain_manila_config('mylvm/lvm_share_mirrors').with_value('1')
      is_expected.to contain_manila_config('mylvm/lvm_share_volume_group').with_value('lvm-shares')
      is_expected.to contain_manila_config('mylvm/lvm_share_helpers').with_value(
        'CIFS=manila.share.drivers.helpers.CIFSHelperUserAccess,NFS=manila.share.drivers.helpers.NFSHelper')
      is_expected.to contain_manila_config('mylvm/backend_availability_zone').with_value(
        'my_zone')
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'lvm share driver'
    end
  end
end
