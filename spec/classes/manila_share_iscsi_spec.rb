require 'spec_helper'

describe 'manila::share::iscsi' do

  let :req_params do {
    :iscsi_ip_address => '127.0.0.2',
    :iscsi_helper => 'tgtadm'
  }
  end

  let :facts do
    {:osfamily => 'Debian'}
  end

  describe 'with default params' do

    let :params do
      req_params
    end

    it { should contain_manila_config('DEFAULT/iscsi_ip_address').with(
      :value => '127.0.0.2'
    ) }
    it { should contain_manila_config('DEFAULT/iscsi_helper').with(
      :value => 'tgtadm'
    ) }
    it { should contain_manila_config('DEFAULT/share_group').with(
      :value => 'manila-shares'
    ) }

  end

  describe 'with RedHat' do

    let :params do
      req_params
    end

    let :facts do
      {:osfamily => 'RedHat'}
    end

    it { should contain_file_line('manila include').with(
      :line => 'include /etc/manila/shares/*',
      :path => '/etc/tgt/targets.conf'
    ) }

  end

  describe 'with lioadm' do

    let :params do {
      :iscsi_ip_address => '127.0.0.2',
      :iscsi_helper => 'lioadm'
    }
    end

    let :facts do
      {:osfamily => 'RedHat'}
    end

    it { should contain_package('targetcli').with_ensure('present')}

  end

end
