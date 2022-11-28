require 'spec_helper'

describe 'manila::scheduler' do

  shared_examples_for 'manila::scheduler' do

    context 'with default parameters' do

      it { is_expected.to contain_class('manila::params') }

      it { is_expected.to contain_manila_config('DEFAULT/scheduler_driver').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to contain_service('manila-scheduler').with(
        :name      => platform_params[:scheduler_service],
        :enable    => true,
        :ensure    => 'running',
        :hasstatus => true,
        :tag       => 'manila-service',
      ) }
    end

    context 'with parameters' do

      let :params do
        {
          :scheduler_driver => 'manila.scheduler.filter_scheduler.FilterScheduler',
        }
      end

      it { is_expected.to contain_manila_config('DEFAULT/scheduler_driver').with_value('manila.scheduler.filter_scheduler.FilterScheduler') }
    end

    context 'with manage_service false' do
      let :params do
        {
          :manage_service => false
        }
      end
      it 'should not configure the service' do
        is_expected.to_not contain_service('manila-scheduler')
      end
    end
  end

  shared_examples_for 'manila::scheduler on Debian' do
    context 'with default parameters' do
      it { is_expected.to contain_package('manila-scheduler').with(
        :name   => 'manila-scheduler',
        :ensure => 'present',
        :tag    => ['openstack', 'manila-package'],
      ) }
    end

    context 'with parameters' do
      let :params do
        {
          :package_ensure => 'installed'
        }
      end

      it { is_expected.to contain_package('manila-scheduler').with(
        :name   => 'manila-scheduler',
        :ensure => 'installed',
        :tag    => ['openstack', 'manila-package'],
      ) }
    end
  end

  shared_examples_for 'manila::scheduler on RedHat' do
    context 'with default parameters' do
      it { is_expected.to_not contain_package('manila-scheduler') }
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
        case facts[:osfamily]
        when 'Debian'
          { :scheduler_service => 'manila-scheduler' }
        when 'RedHat'
          { :scheduler_service => 'openstack-manila-scheduler' }
        end
      end

      it_behaves_like 'manila::scheduler'
      it_behaves_like "manila::scheduler on #{facts[:osfamily]}"
    end
  end

end
