require 'spec_helper'

describe 'manila::backend::netapp' do

  let(:title) {'mynetapp'}

  let :req_params do
    {
      :driver_handles_share_servers => true,
      :netapp_login                 => 'netapp',
      :netapp_password              => 'password',
      :netapp_server_hostname       => '192.0.2.2',
    }
  end

  let :default_params do
    {
      :backend_availability_zone               => '<SERVICE DEFAULT>',
      :netapp_transport_type                   => '<SERVICE DEFAULT>',
      :netapp_storage_family                   => '<SERVICE DEFAULT>',
      :netapp_server_port                      => '<SERVICE DEFAULT>',
      :netapp_volume_name_template             => '<SERVICE DEFAULT>',
      :netapp_vserver                          => '<SERVICE DEFAULT>',
      :netapp_vserver_name_template            => '<SERVICE DEFAULT>',
      :netapp_lif_name_template                => '<SERVICE DEFAULT>',
      :netapp_aggregate_name_search_pattern    => '<SERVICE DEFAULT>',
      :netapp_root_volume_aggregate            => '<SERVICE DEFAULT>',
      :netapp_root_volume                      => '<SERVICE DEFAULT>',
      :netapp_port_name_search_pattern         => '<SERVICE DEFAULT>',
      :netapp_trace_flags                      => '<SERVICE DEFAULT>',
      :reserved_share_percentage               => '<SERVICE DEFAULT>',
      :reserved_share_from_snapshot_percentage => '<SERVICE DEFAULT>',
      :reserved_share_extend_percentage        => '<SERVICE DEFAULT>',
      :max_over_subscription_ratio             => '<SERVICE DEFAULT>',
    }
  end

  shared_examples_for 'netapp share driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures netapp share driver' do
      is_expected.to contain_manila_config("mynetapp/share_driver").with_value(
        'manila.share.drivers.netapp.common.NetAppDriver')
      params_hash.each_pair do |config,value|
        is_expected.to contain_manila_config("mynetapp/#{config}").with_value( value )
      end
    end

    it 'marks netapp_password as secret' do
      is_expected.to contain_manila_config("mynetapp/netapp_password").with_secret( true )
    end
  end

  shared_examples 'manila::backend::netapp' do
    context 'with default parameters' do
      let :params do
        req_params
      end

      it_configures 'netapp share driver'
    end

    context 'with provided parameters' do
      let :params do
        req_params.merge({
          :backend_availability_zone               => 'my_zone',
          :netapp_transport_type                   => 'https',
          :netapp_storage_family                   => 'ontap_cluster',
          :netapp_server_port                      => '443',
          :netapp_volume_name_template             => 'share_%(share_id)s',
          :netapp_vserver                          => 'manilasvm',
          :netapp_vserver_name_template            => 'os_%s',
          :netapp_lif_name_template                => 'os_%(net_allocation_id)s',
          :netapp_aggregate_name_search_pattern    => '(.*)',
          :netapp_root_volume_aggregate            => 'aggr1',
          :netapp_root_volume                      => 'rootvolume',
          :netapp_port_name_search_pattern         => '(.*)',
          :netapp_trace_flags                      => 'method,api',
          :reserved_share_percentage               => 10.0,
          :reserved_share_from_snapshot_percentage => 10.1,
          :reserved_share_extend_percentage        => 10.2,
          :max_over_subscription_ratio             => 1.5,
        })
      end

      it_configures 'netapp share driver'
    end

    context 'with invalid password' do
      before do
        req_params.merge!({
          :netapp_password => true,
        })
      end

      it { is_expected.to raise_error(Puppet::Error) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'manila::backend::netapp'
    end
  end
end
