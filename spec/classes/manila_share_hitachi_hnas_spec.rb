require 'spec_helper'

describe 'manila::share::hitachi_hnas' do

  let :params do
    {
      :driver_handles_share_servers        => false,
      :hitachi_hnas_ip                     => '172.24.44.15',
      :hitachi_hnas_username               => 'supervisor',
      :hitachi_hnas_password               => 'supervisor',
      :hitachi_hnas_evs_id                 => '1',
      :hitachi_hnas_evs_ip                 => ' 172.24.53.1',
      :hitachi_hnas_file_system_name       => 'FS-Manila',
    }
  end

  shared_examples_for 'hitachi hnas share driver' do
    it 'configures hitachi nas share driver' do
      is_expected.to contain_manila_config("DEFAULT/share_driver").with_value(
        'manila.share.drivers.hitachi.hds_hnas.HDSHNASDriver')
      params.each_pair do |config,value|
        is_expected.to contain_manila_config("DEFAULT/#{config}").with_value( value )
      end
    end

    it 'marks hitachi_hnas_password as secret' do
      is_expected.to contain_manila_config("DEFAULT/hitachi_hnas_password").with_secret( true )
    end
  end


  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
      }).each do |os,facts|
        context "on #{os}" do
          let (:facts) do
            facts.merge(OSDefaults.get_facts({ :osfamily => "#{os}" }))
          end

          it_configures 'hitachi hnas share driver'
        end
      end

end
