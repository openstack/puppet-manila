require 'spec_helper'

describe 'manila::share' do

  shared_examples_for 'manila-share' do
    let :pre_condition do
      'class { "manila": }'
    end

    it { is_expected.to contain_package('manila-share').with(
      :name   => platform_params[:package_name],
      :ensure => 'present',
      :tag    => ['openstack', 'manila-package'],
    ) }
    it { is_expected.to contain_service('manila-share').with(
      'hasstatus' => true,
      'tag'       => 'manila-service',
    )}

    describe 'with manage_service false' do
      let :params do
        { 'manage_service' => false }
      end
      it 'should not change the state of the service' do
        is_expected.to contain_service('manila-share').without_ensure
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :fqdn => 'some.host.tld'}))
      end

      let :platform_params do
        case facts[:osfamily]
        when 'Debian'
          { :package_name => 'manila-share' }
        when 'RedHat'
          { :package_name => 'openstack-manila-share' }
        end
      end

      it_behaves_like 'manila-share'
    end
  end
end
