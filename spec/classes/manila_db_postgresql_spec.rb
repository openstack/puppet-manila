require 'spec_helper'

describe 'manila::db::postgresql' do

  shared_examples_for 'manila::db::postgresql' do
    let :req_params do
      { :password => 'manilapass' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_class('manila::deps') }

      it { is_expected.to contain_openstacklib__db__postgresql('manila').with(
        :user       => 'manila',
        :password   => 'manilapass',
        :dbname     => 'manila',
        :encoding   => nil,
        :privileges => 'ALL',
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          # puppet-postgresql requires the service_provider fact provided by
          # puppetlabs-postgresql.
          :service_provider => 'systemd'
        }))
      end

      it_configures 'manila::db::postgresql'
    end
  end

end
