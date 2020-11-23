require 'spec_helper'

describe 'manila::db::sync' do

  shared_examples_for 'manila-dbsync' do

    it { is_expected.to contain_class('manila::deps') }

    it 'runs manila-db-sync' do
      is_expected.to contain_exec('manila-manage db_sync').with(
        :command     => 'manila-manage db sync',
        :path        => '/usr/bin',
        :refreshonly => 'true',
        :user        => 'manila',
        :try_sleep   => 5,
        :tries       => 10,
        :timeout     => 300,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[manila::install::end]',
                         'Anchor[manila::config::end]',
                         'Anchor[manila::dbsync::begin]'],
        :notify      => 'Anchor[manila::dbsync::end]',
        :tag         => 'openstack-db',
      )
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'manila-dbsync'
    end
  end

end

