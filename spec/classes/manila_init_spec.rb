require 'spec_helper'
describe 'manila' do
  let :req_params do
    {
      :purge_config    => false,
    }
  end

  shared_examples_for 'manila' do
    context 'with only required params' do
      let :params do
        req_params
      end

      it { is_expected.to contain_class('manila::params') }

      it 'passes purge to resource' do
        is_expected.to contain_resources('manila_config').with({
          :purge => false
        })
      end

      it 'should contain default config' do
        is_expected.to contain_oslo__messaging__default('manila_config').with(
          :executor_thread_pool_size => '<SERVICE DEFAULT>',
          :transport_url             => '<SERVICE DEFAULT>',
          :rpc_response_timeout      => '<SERVICE DEFAULT>',
          :control_exchange          => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__notifications('manila_config').with(
          :transport_url => '<SERVICE DEFAULT>',
          :driver        => 'messaging',
          :topics        => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__rabbit('manila_config').with(
          :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
          :amqp_durable_queues             => '<SERVICE DEFAULT>',
          :rabbit_ha_queues                => '<SERVICE DEFAULT>',
          :kombu_failover_strategy         => '<SERVICE DEFAULT>',
          :heartbeat_in_pthread            => '<SERVICE DEFAULT>',
          :rabbit_quorum_queue             => '<SERVICE DEFAULT>',
          :rabbit_transient_quorum_queue   => '<SERVICE DEFAULT>',
          :rabbit_quorum_delivery_limit    => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_length => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_bytes  => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_manila_config('DEFAULT/storage_availability_zone').with(
          :value => 'nova'
        )
        is_expected.to contain_manila_config('DEFAULT/api_paste_config').with(
          :value => '/etc/manila/api-paste.ini'
        )
        is_expected.to contain_manila_config('DEFAULT/rootwrap_config').with(
          :value => '/etc/manila/rootwrap.conf'
        )
        is_expected.to contain_manila_config('DEFAULT/state_path').with(
          :value => '/var/lib/manila'
        )
        is_expected.to contain_manila_config('DEFAULT/host').with(
          :value => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_manila_config('DEFAULT/report_interval').with(
          :value => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_manila_config('DEFAULT/periodic_interval').with(
          :value => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_manila_config('DEFAULT/periodic_fuzzy_delay').with(
          :value => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_manila_config('DEFAULT/service_down_time').with(
          :value => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_oslo__concurrency('manila_config').with(
          :lock_path => platform_params[:lock_path]
        )
      end
    end

    context 'with enable ha queues' do
      let :params do
        req_params.merge({'rabbit_ha_queues' => true})
      end

      it 'should contain rabbit_ha_queues' do
        is_expected.to contain_oslo__messaging__rabbit('manila_config').with(
          :rabbit_ha_queues        => true,
        )
      end
    end

    context 'with SSL enabled' do
      let :params do
        req_params.merge!({
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '/path/to/ssl/ca/certs',
          :kombu_ssl_certfile => '/path/to/ssl/cert/file',
          :kombu_ssl_keyfile  => '/path/to/ssl/keyfile',
          :kombu_ssl_version  => 'TLSv1'
        })
      end

      it { is_expected.to contain_oslo__messaging__rabbit('manila_config').with(
        :rabbit_use_ssl     => true,
        :kombu_ssl_ca_certs => '/path/to/ssl/ca/certs',
        :kombu_ssl_certfile => '/path/to/ssl/cert/file',
        :kombu_ssl_keyfile  => '/path/to/ssl/keyfile',
        :kombu_ssl_version  => 'TLSv1'
      )}
    end

    context 'with SSL enabled without kombu' do
      let :params do
        req_params.merge!({
          :rabbit_use_ssl     => true,
        })
      end

      it { is_expected.to contain_oslo__messaging__rabbit('manila_config').with(
        :rabbit_use_ssl     => true,
      )}
    end

    context 'with SSL disabled' do
      let :params do
        req_params.merge!({
          :rabbit_use_ssl     => false,
        })
      end

      it { is_expected.to contain_oslo__messaging__rabbit('manila_config').with(
        :rabbit_use_ssl     => false,
      )}
    end

    context 'with amqp_durable_queues disabled' do
      let :params do
        req_params.merge({
          :amqp_durable_queues => false,
        })
      end

      it { is_expected.to contain_oslo__messaging__rabbit('manila_config').with(
        :amqp_durable_queues => false,
      )}
    end

    context 'with amqp_durable_queues enabled' do
      let :params do
        req_params.merge({
          :amqp_durable_queues => true,
        })
      end

      it { is_expected.to contain_oslo__messaging__rabbit('manila_config').with(
        :amqp_durable_queues => true,
      )}
    end

    context 'with SSL socket options set' do
      let :params do
        {
          :use_ssl         => true,
          :cert_file       => '/path/to/cert',
          :ca_file         => '/path/to/ca',
          :key_file        => '/path/to/key',
        }
      end

      it { is_expected.to contain_manila_config('DEFAULT/ssl_ca_file').with_value('/path/to/ca') }
      it { is_expected.to contain_manila_config('DEFAULT/ssl_cert_file').with_value('/path/to/cert') }
      it { is_expected.to contain_manila_config('DEFAULT/ssl_key_file').with_value('/path/to/key') }
    end

    context 'with SSL socket options set to false' do
      let :params do
        {
          :use_ssl         => false,
          :cert_file       => false,
          :ca_file         => false,
          :key_file        => false,
        }
      end

      it { is_expected.to contain_manila_config('DEFAULT/ssl_ca_file').with_ensure('absent') }
      it { is_expected.to contain_manila_config('DEFAULT/ssl_cert_file').with_ensure('absent') }
      it { is_expected.to contain_manila_config('DEFAULT/ssl_key_file').with_ensure('absent') }
    end

    context 'with transport_url entries' do

      let :params do
        {
          :default_transport_url      => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout       => '120',
          :control_exchange           => 'manila',
          :notification_transport_url => 'rabbit://rabbit_user:password@localhost:5673',
          :executor_thread_pool_size  => 64,
        }
      end

      it { is_expected.to contain_oslo__messaging__default('manila_config').with(
        :executor_thread_pool_size => 64,
        :transport_url             => 'rabbit://rabbit_user:password@localhost:5673',
        :rpc_response_timeout      => '120',
        :control_exchange          => 'manila',
      ) }

      it { is_expected.to contain_oslo__messaging__notifications('manila_config').with(
        :transport_url => 'rabbit://rabbit_user:password@localhost:5673'
      ) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end
      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          {
            :lock_path => '/var/lock/manila'
          }
        when 'RedHat'
          {
            :lock_path => '/var/lib/manila/tmp'
          }
        end
      end

      it_behaves_like 'manila'
    end
  end
end
