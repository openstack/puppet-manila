require 'spec_helper'

describe 'manila::scheduler' do

  shared_examples_for 'manila::scheduler on Debian' do

    context 'with default parameters' do

      it { is_expected.to contain_class('manila::params') }

      it { is_expected.to contain_package('manila-scheduler').with(
        :name      => 'manila-scheduler',
        :ensure    => 'present',
        :tag       => ['openstack', 'manila-package'],
      ) }

      it { is_expected.to contain_service('manila-scheduler').with(
        :name      => 'manila-scheduler',
        :enable    => true,
        :ensure    => 'running',
        :hasstatus => true,
        :tag       => 'manila-service',
      ) }
    end

    context 'with parameters' do

      let :params do
        { :scheduler_driver => 'manila.scheduler.filter_scheduler.FilterScheduler',
          :package_ensure   => 'present'
        }
      end

      it { is_expected.to contain_manila_config('DEFAULT/scheduler_driver').with_value('manila.scheduler.filter_scheduler.FilterScheduler') }
      it { is_expected.to contain_package('manila-scheduler').with_ensure('present') }
    end

    context 'with manage_service false' do
      let :params do
        { 'manage_service' => false
        }
      end
      it 'should not configure the service' do
        is_expected.to_not contain_service('manila-scheduler')
      end
    end
  end


  shared_examples_for 'manila::scheduler on RedHat' do

    context 'with default parameters' do

      it { is_expected.to contain_class('manila::params') }

      it { is_expected.to contain_service('manila-scheduler').with(
        :name    => 'openstack-manila-scheduler',
        :enable  => true,
        :ensure  => 'running',
        :tag     => 'manila-service',
      ) }
    end

    context 'with parameters' do

      let :params do
        { :scheduler_driver => 'manila.scheduler.filter_scheduler.FilterScheduler' }
      end

      it { is_expected.to contain_manila_config('DEFAULT/scheduler_driver').with_value('manila.scheduler.filter_scheduler.FilterScheduler') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :fqdn => 'some.host.tld'}))
      end
      it_behaves_like "manila::scheduler on #{facts[:osfamily]}"
    end
  end

end
