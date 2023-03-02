require 'spec_helper'

describe 'manila::share::generic' do

  let :params do
    {
      :driver_handles_share_servers        => true,
      :smb_template_config_path            => '$state_path/smb.conf',
      :volume_name_template                => 'manila-share-%s',
      :volume_snapshot_name_template       => 'manila-snapshot-%s',
      :share_mount_path                    => '/shares',
      :max_time_to_create_volume           => 180,
      :max_time_to_attach                  => 120,
      :service_instance_smb_config_path    => '$share_mount_path/smb.conf',
      :share_volume_fstype                 => 'ext4',
      :cinder_volume_type                  => 'gold',
      :delete_share_server_with_last_share => 'True',
      :unmanage_remove_access_rules        => 'True',
      :automatic_share_server_cleanup      => 'False',
    }
  end

  shared_examples_for 'manila::share::generic' do
    context 'generic share driver' do
      it 'configures generic share driver' do
        is_expected.to contain_manila_config('DEFAULT/share_driver').with_value(
          'manila.share.drivers.generic.GenericShareDriver')
        is_expected.to contain_manila_config('DEFAULT/share_helpers').with_value(
          'CIFS=manila.share.drivers.helpers.CIFSHelperIPAccess,'\
          'NFS=manila.share.drivers.helpers.NFSHelper')
        params.each_pair do |config,value|
          is_expected.to contain_manila_config("DEFAULT/#{config}").with_value( value )
        end
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
      it_behaves_like 'manila::share::generic'
    end
  end

end
