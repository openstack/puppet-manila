require 'spec_helper'

describe 'manila::backend::iscsi' do

  let(:title) {'hippo'}

  let :req_params do {
    :iscsi_ip_address => '127.0.0.2',
    :iscsi_helper => 'tgtadm',
  }
  end

  let :facts do
    {:osfamily => 'Debian'}
  end

  let :params do
    req_params
  end

  describe 'with default params' do

    it 'should configure iscsi driver' do
      should contain_manila_config('hippo/volume_backend_name').with(
        :value => 'hippo')
      should contain_manila_config('hippo/iscsi_ip_address').with(
        :value => '127.0.0.2')
      should contain_manila_config('hippo/iscsi_helper').with(
        :value => 'tgtadm')
      should contain_manila_config('hippo/volume_group').with(
        :value => 'manila-volumes')
    end
  end

  describe 'with RedHat' do

    let :facts do
      {:osfamily => 'RedHat'}
    end

    it { should contain_file_line('manila include').with(
      :line => 'include /etc/manila/volumes/*',
      :path => '/etc/tgt/targets.conf'
    ) }

  end

end
