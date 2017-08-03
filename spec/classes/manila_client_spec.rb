require 'spec_helper'

describe 'manila::client' do

  shared_examples_for 'manila client' do

    it { is_expected.to contain_class('manila::deps') }
    it { is_expected.to contain_class('manila::params') }

    it 'installs manila client package' do
      is_expected.to contain_package('python-manilaclient').with(
        :ensure => 'present',
        :name   => platform_params[:client_package],
        :tag    => ['openstack', 'manila-support-package']
      )
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let :platform_params do
        { :client_package => 'python-manilaclient' }
      end

      it_behaves_like 'manila client'
    end
  end

end
