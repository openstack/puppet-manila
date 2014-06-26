require 'spec_helper'

describe 'manila::backend::san' do
  let (:title) { 'mysan' }

  let :params do
    { :share_driver   => 'manila.share.san.SolarisISCSIDriver',
      :san_ip          => '127.0.0.1',
      :san_login       => 'cluster_operator',
      :san_password    => '007',
      :san_clustername => 'storage_cluster' }
  end

  let :default_params do
    { :san_thin_provision => true,
      :san_login          => 'admin',
      :san_ssh_port       => 22,
      :san_is_local       => false,
      :ssh_conn_timeout   => 30,
      :ssh_min_pool_conn  => 1,
      :ssh_max_pool_conn  => 5 }
  end

  shared_examples_for 'a san share driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures manila share driver' do
      params_hash.each_pair do |config,value|
        should contain_manila_config("mysan/#{config}").with_value( value )
      end
    end
  end


  context 'with parameters' do
    it_configures 'a san share driver'
  end
end
