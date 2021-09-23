require 'spec_helper'

describe 'manila::backend::dellemc_isilon' do

  let(:title) {'dellemc_isilon'}

  let :params do
    {
      :driver_handles_share_servers         => false,
      :emc_nas_login                        => 'admin',
      :emc_nas_password                     => 'password',
      :emc_nas_server                       => '127.0.0.2',
      :emc_share_backend                    => 'isilon',
      :emc_nas_root_dir                     => '',
    }
  end

  let :default_params do
    {
      :backend_availability_zone => '<SERVICE DEFAULT>',
      :emc_nas_server_port       => 8080,
      :emc_nas_server_secure     => true,
    }
  end

  shared_examples_for 'dell emc isilon share driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures dell emc isilon share driver' do
      is_expected.to contain_manila_config("dellemc_isilon/share_driver").with_value(
        'manila.share.drivers.dell_emc.driver.EMCShareDriver')
      params_hash.each_pair do |config,value|
        is_expected.to contain_manila_config("dellemc_isilon/#{config}").with_value( value )
      end
    end

    it 'marks emc_nas_password as secret' do
      is_expected.to contain_manila_config("dellemc_isilon/emc_nas_password").with_secret( true )
    end
  end

  shared_examples 'manila::backend::dellemc_isilon' do
    context 'with default parameters' do
      before do
        params = {}
      end

      it_configures 'dell emc isilon share driver'
    end

    context 'with provided parameters' do
      it_configures 'dell emc isilon share driver'
    end

    context 'with share server config' do
     before do
       params.merge!({
          :emc_nas_password => true,
        })
      end

      it { is_expected.to raise_error(Puppet::Error) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'manila::backend::dellemc_isilon'
    end
  end
end
