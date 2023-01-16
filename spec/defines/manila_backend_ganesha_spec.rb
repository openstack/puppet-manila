require 'spec_helper'

describe 'manila::backend::ganesha' do

  shared_examples_for 'manila::backend::ganesha' do
    let(:title) {'ganesha'}

    context 'with defaults' do
      let :params do
        {}
      end

      it { is_expected.to contain_package('nfs-ganesha').with(
        :name   => 'nfs-ganesha',
        :ensure => 'installed'
      ) }

      it 'set the default values' do
        is_expected.to contain_manila_config('ganesha/ganesha_config_dir').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('ganesha/ganesha_config_path').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('ganesha/ganesha_service_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('ganesha/ganesha_db_path').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('ganesha/ganesha_export_dir').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('ganesha/ganesha_export_template_dir').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('ganesha/ganesha_rados_store_enable').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('ganesha/ganesha_rados_store_pool_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('ganesha/ganesha_rados_export_counter').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('ganesha/ganesha_rados_export_index').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with specific parameters' do
      let :params do
        {
          :ganesha_config_dir            => '/etc/ganesha',
          :ganesha_config_path           => '/etc/ganesha/ganesha.conf',
          :ganesha_service_name          => 'ganesha.nfsd',
          :ganesha_db_path               => '$state_path/manila-ganesha.db',
          :ganesha_export_dir            => '/etc/ganesha/export.d',
          :ganesha_export_template_dir   => '/etc/manila/ganesha-export-templ.d',
          :ganesha_rados_store_enable    => true,
          :ganesha_rados_store_pool_name => 'storepool',
          :ganesha_rados_export_counter  => 'ganesha-export-counter',
          :ganesha_rados_export_index    => 'ganesha-export-index',
        }
      end

      it 'Adds NFS Ganesha options to the share drivers' do
        params.each_pair do |config,value|
          is_expected.to contain_manila_config("ganesha/#{config}").with_value(value)
        end
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
      it_configures 'manila::backend::ganesha'
    end
  end
end
