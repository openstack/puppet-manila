require 'spec_helper'

describe 'manila::backend::service_instance' do

  let(:title) {'DEFAULT'}

  let :params do
    {
      :create_service_image                   => true,
      :service_instance_name_template         => 'manila_service_instance_%s',
      :service_instance_user                  => 'user1',
      :service_instance_password              => 'pass1',
      :manila_service_keypair_name            => 'manila-service',
      :path_to_public_key                     => '~/.ssh/id_rsa.pub',
      :path_to_private_key                    => '~/.ssh/id_rsa',
      :max_time_to_build_instance             => 300,
      :service_instance_security_group        => 'manila-service',
      :service_instance_flavor_id             => 1,
      :service_network_name                   => 'manila_service_network',
      :service_network_cidr                   => '10.254.0.0/16',
      :service_network_division_mask          => 28,
      :interface_driver                       => 'manila.network.linux.interface.OVSInterfaceDriver',
      :connect_share_server_to_tenant_network => false,
    }
  end

  shared_examples 'manila::backend::service_instance' do
    context 'with default parameters' do
      it 'configures service instance' do
        expect {
          params.each_pair do |config,value|
            is_expected.to contain_manila_config("DEFAULT/#{config}").with_value( value )
          end
        }.to raise_error(Puppet::Error, /Missing required parameter service_image_location/)
      end
    end

    context 'with service image provided' do
      let (:req_params) { params.merge!({
        :service_image_name     => 'manila-service-image',
        :service_image_location => 'http://example.com/manila_service_image.iso',
      }) }

      it 'creates Glance image' do
        is_expected.to contain_glance_image(req_params[:service_image_name]).with(
          :ensure           => 'present',
          :is_public        => 'yes',
          :container_format => 'bare',
          :disk_format      => 'qcow2',
          :source           => req_params[:service_image_location]
          )
      end
    end

    context 'with create_service_image false' do
      let (:req_params) { params.merge!({
        :create_service_image => false,
        :service_image_name   => 'manila-service-image',
      }) }

      it 'does not create Glance image' do
        is_expected.to_not contain_glance_image(req_params[:service_image_name])
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'manila::backend::service_instance'
    end
  end
end
