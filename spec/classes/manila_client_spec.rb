require 'spec_helper'

describe 'manila::client' do

  let :params do
    {}
  end

  let :default_params do
    { :package_ensure   => 'present' }
  end

  shared_examples_for 'manila client' do
    let :p do
      default_params.merge(params)
    end

    it { is_expected.to contain_class('manila::params') }
  
    it 'installs manila client package' do
      it is_expected.to contain_package('python-manilaclient').with(
        :name   => 'python-manilaclient',
        :ensure => p[:package_ensure],
        :tag    => ['openstack', 'manila-support-package'],
      )
    end

  end

  let :facts do
    @default_facts.merge({:osfamily => 'Debian'})
  end
  context 'with params' do
    let :params do
      {:package_ensure => 'latest'}
    end
    it { is_expected.to contain_package('python-manilaclient').with_ensure('latest') }
  end
end
