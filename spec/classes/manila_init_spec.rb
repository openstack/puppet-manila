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
          :driver        => '<SERVICE DEFAULT>',
          :topics        => '<SERVICE DEFAULT>',
          :retry         => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__rabbit('manila_config').with(
          :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
          :amqp_durable_queues             => '<SERVICE DEFAULT>',
          :amqp_auto_delete                => '<SERVICE DEFAULT>',
          :rabbit_ha_queues                => '<SERVICE DEFAULT>',
          :kombu_failover_strategy         => '<SERVICE DEFAULT>',
          :heartbeat_timeout_threshold     => '<SERVICE DEFAULT>',
          :heartbeat_rate                  => '<SERVICE DEFAULT>',
          :heartbeat_in_pthread            => nil,
          :rabbit_qos_prefetch_count       => '<SERVICE DEFAULT>',
          :rabbit_quorum_queue             => '<SERVICE DEFAULT>',
          :rabbit_transient_quorum_queue   => '<SERVICE DEFAULT>',
          :rabbit_transient_queues_ttl     => '<SERVICE DEFAULT>',
          :rabbit_quorum_delivery_limit    => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_length => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_bytes  => '<SERVICE DEFAULT>',
          :enable_cancel_on_failover       => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_manila_config('DEFAULT/storage_availability_zone').with(
          :value => '<SERVICE DEFAULT>'
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

    context 'with amqp options' do
      let :params do
        req_params.merge({
          :amqp_durable_queues => true,
          :amqp_auto_delete    => false,
        })
      end

      it { is_expected.to contain_oslo__messaging__rabbit('manila_config').with(
        :amqp_durable_queues => true,
        :amqp_auto_delete    => false,
      )}
    end

    context 'with SSL socket options set' do
      let :params do
        {
          :use_ssl   => true,
          :cert_file => '/path/to/cert',
          :ca_file   => '/path/to/ca',
          :key_file  => '/path/to/key',
        }
      end

      it { is_expected.to contain_oslo__service__ssl('manila_config').with(
        :ca_file   => '/path/to/ca',
        :cert_file => '/path/to/cert',
        :key_file  => '/path/to/key'
      )}
    end

    context 'with SSL socket options set to false' do
      let :params do
        {
          :use_ssl => false,
        }
      end

      it { is_expected.to contain_oslo__service__ssl('manila_config') }
    end

    context 'with transport_url entries' do

      let :params do
        {
          :default_transport_url      => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout       => '120',
          :control_exchange           => 'manila',
          :notification_transport_url => 'rabbit://rabbit_user:password@localhost:5673',
          :notification_driver        => 'messagingv2',
          :notification_topics        => ['notifications'],
          :notification_retry         => 10,
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
        :transport_url => 'rabbit://rabbit_user:password@localhost:5673',
        :driver        => 'messagingv2',
        :topics        => ['notifications'],
        :retry         => 10,
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
