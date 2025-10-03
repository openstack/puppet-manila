require 'spec_helper'

describe 'manila::backend::service_instance' do

  let(:title) { 'mybackend' }

  let :params do
    {
      :service_instance_user     => 'user1',
      :service_instance_password => 'pass1',
    }
  end

  shared_examples 'manila::backend::service_instance' do
    context 'with default parameters' do
      it 'fails due to missing service_image_location' do
        is_expected.to raise_error(Puppet::Error, /Missing required parameter service_image_location/)
      end
    end

    context 'with service image provided' do
      before do
        params.merge!({
          :service_image_location => 'http://example.com/manila_service_image.iso',
        })
      end

      it 'configures service instance' do
        is_expected.to contain_manila_config('mybackend/service_image_name').with_value('manila-service-image')
        is_expected.to contain_manila_config('mybackend/service_instance_name_template').with_value('manila_service_instance_%s')
        is_expected.to contain_manila_config('mybackend/service_instance_user').with_value('user1')
        is_expected.to contain_manila_config('mybackend/service_instance_password').with_value('pass1').with_secret(true)
        is_expected.to contain_manila_config('mybackend/manila_service_keypair_name').with_value('manila-service')
        is_expected.to contain_manila_config('mybackend/path_to_public_key').with_value('~/.ssh/id_rsa.pub')
        is_expected.to contain_manila_config('mybackend/path_to_private_key').with_value('~/.ssh/id_rsa')
        is_expected.to contain_manila_config('mybackend/max_time_to_build_instance').with_value(300)
        is_expected.to contain_manila_config('mybackend/service_instance_security_group').with_value('manila-service')
        is_expected.to contain_manila_config('mybackend/service_instance_flavor_id').with_value(1)
        is_expected.to contain_manila_config('mybackend/service_network_name').with_value('manila_service_network')
        is_expected.to contain_manila_config('mybackend/service_network_cidr').with_value('10.254.0.0/16')
        is_expected.to contain_manila_config('mybackend/service_network_division_mask').with_value(28)
        is_expected.to contain_manila_config('mybackend/interface_driver').with_value('manila.network.linux.interface.OVSInterfaceDriver')
        is_expected.to contain_manila_config('mybackend/connect_share_server_to_tenant_network').with_value(false)
      end

      it 'creates Glance image' do
        is_expected.to contain_glance_image('manila-service-image').with(
          :ensure           => 'present',
          :is_public        => 'yes',
          :container_format => 'bare',
          :disk_format      => 'qcow2',
          :source           => 'http://example.com/manila_service_image.iso'
        )
      end
    end

    context 'with custom service image name' do
      before do
        params.merge!({
          :service_image_name     => 'custom-image',
          :service_image_location => 'http://example.com/manila_service_image.iso',
        })
      end

      it 'configures service instance' do
        is_expected.to contain_manila_config('mybackend/service_image_name').with_value('custom-image')
      end

      it 'creates Glance image' do
        is_expected.to contain_glance_image('custom-image').with(
          :ensure           => 'present',
          :is_public        => 'yes',
          :container_format => 'bare',
          :disk_format      => 'qcow2',
          :source           => 'http://example.com/manila_service_image.iso',
        )
      end
    end

    context 'with create_service_image false' do
      before do
        params.merge!({
          :create_service_image => false,
        })
      end

      it 'does not create Glance image' do
        is_expected.to_not contain_glance_image('manila-service-image')
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
