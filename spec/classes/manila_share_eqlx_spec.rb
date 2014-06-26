require 'spec_helper'

describe 'manila::share::eqlx' do

  let :params do {
      :san_ip               => '192.168.100.10',
      :san_login            => 'grpadmin',
      :san_password         => '12345',
      :san_thin_provision   => true,
      :eqlx_group_name      => 'group-a',
      :eqlx_pool            => 'apool',
      :eqlx_use_chap        => true,
      :eqlx_chap_login      => 'chapadm',
      :eqlx_chap_password   => '56789',
      :eqlx_cli_timeout     => 31,
      :eqlx_cli_max_retries => 6,
  }
  end

  describe 'eqlx share driver' do
    it 'configures eqlx share driver' do
      should contain_manila_config(
        "DEFAULT/share_driver").with_value(
        'manila.share.drivers.eqlx.DellEQLSanISCSIDriver')
      should contain_manila_config(
        "DEFAULT/share_backend_name").with_value('DEFAULT')

      params.each_pair do |config,value|
        should contain_manila_config("DEFAULT/#{config}").with_value(value)
      end
    end
  end
end
