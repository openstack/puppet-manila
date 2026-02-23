require 'spec_helper'

describe 'manila::api' do
  let :pre_condition do
    "class {'::manila::keystone::authtoken':
       password => 'foo',
     }"
  end

  let :req_params do
    {}
  end


  shared_examples_for 'manila::api' do
    context 'with only required params' do
      let :params do
        req_params
      end

      it { is_expected.to contain_service('manila-api').with(
        'hasstatus' => true,
        'ensure' => 'running',
        'tag' => 'manila-service',
      )}
      it { is_expected.to contain_class('manila::policy') }


      it 'should configure manila api correctly' do
        is_expected.to contain_manila_config('DEFAULT/auth_strategy').with(:value => 'keystone')
        is_expected.to contain_manila_config('DEFAULT/osapi_share_listen').with(:value => '0.0.0.0')
        is_expected.to contain_manila_config('DEFAULT/enabled_share_protocols').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_oslo__middleware('manila_config').with(
          :enable_proxy_headers_parsing => '<SERVICE DEFAULT>',
          :max_request_body_size        => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_manila_config('DEFAULT/default_share_type').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/osapi_share_workers').with(:value => '2')
        is_expected.to contain_manila_config('DEFAULT/admin_only_metadata').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_manila_api_paste_ini('filter:ratelimit/paste.filter_factory').with_ensure('absent')
        is_expected.to contain_manila_api_paste_ini('filter:ratelimit/limits').with_ensure('absent')
      end

      it 'should run db sync' do
        is_expected.to contain_class('manila::db::sync')
      end
    end

    context 'with a default share type' do
      let :params do
        req_params.merge({'default_share_type' => 'default'})
      end
      it { is_expected.to contain_class('manila::policy') }
      it 'should configure the default share type' do
        is_expected.to contain_manila_config('DEFAULT/default_share_type').with(
          :value => 'default'
        )
      end
    end

    context 'with service workers' do
      let :params do
        req_params.merge({'service_workers' => '4'})
      end
      it { is_expected.to contain_class('manila::policy') }
      it 'should configure the share workers' do
        is_expected.to contain_manila_config('DEFAULT/osapi_share_workers').with(
          :value => '4'
        )
      end
    end

    context 'with bind_host' do
      let :params do
        req_params.merge({'bind_host' => '192.168.1.3'})
      end
      it { is_expected.to contain_class('manila::policy') }
      it 'should configure manila api correctly' do
        is_expected.to contain_manila_config('DEFAULT/osapi_share_listen').with(
          :value => '192.168.1.3'
        )
      end
    end

    context 'with oslo.middleware options' do
      let :params do
        req_params.merge({
          'enable_proxy_headers_parsing' => true,
          'max_request_body_size'        => '102400'
        })
      end

      it 'should configure oslo.middleware correctly' do
        is_expected.to contain_oslo__middleware('manila_config').with(
          :enable_proxy_headers_parsing => true,
          :max_request_body_size        => '102400',
        )
      end
    end

    context 'with enabled false' do
      let :params do
        req_params.merge({'enabled' => false})
      end
      it { is_expected.to contain_class('manila::policy') }
      it 'should stop the service' do
        is_expected.to contain_service('manila-api').with_ensure('stopped')
      end
      it 'includes manila::db::sync' do
        is_expected.to contain_class('manila::db::sync')
      end
    end

    context 'with sync_db false' do
      let :params do
        req_params.merge({'sync_db' => false})
      end
      it { is_expected.to contain_class('manila::policy') }
      it 'should not include manila::db::sync' do
        is_expected.to_not contain_class('manila::db::sync')
      end
    end

    context 'with manage_service false' do
      let :params do
        req_params.merge({'manage_service' => false})
      end
      it { is_expected.to contain_class('manila::policy') }
      it 'should not configure the service' do
        is_expected.to_not contain_service('manila-api')
      end
    end

    context 'with ratelimits' do
      let :params do
        req_params.merge({ :ratelimits => '(GET, "*", .*, 100, MINUTE);(POST, "*", .*, 200, MINUTE)' })
      end

      it { is_expected.to contain_class('manila::policy') }
      it { is_expected.to contain_manila_api_paste_ini('filter:ratelimit/paste.filter_factory').with(
        :value => 'manila.api.v2.limits:RateLimitingMiddleware.factory'
      )}
      it { is_expected.to contain_manila_api_paste_ini('filter:ratelimit/limits').with(
        :value => '(GET, "*", .*, 100, MINUTE);(POST, "*", .*, 200, MINUTE)'
      )}
    end

    context 'when running manila-api in wsgi' do
      let :params do
        req_params.merge!({ :service_name => 'httpd' })
      end

      let :pre_condition do
        "include apache
         class { 'manila': }
         class { 'manila::keystone::authtoken':
           password => 'foo',
         }"
      end

      it 'configures manila-api service with Apache' do
        is_expected.to contain_service('manila-api').with(
          :ensure => 'stopped',
          :enable => false,
          :tag    => ['manila-service'],
        )
      end
    end

    context 'enabled_share_protocols is set' do
      let :params do
        req_params.merge!({
          :enabled_share_protocols => 'NFS'
        })
      end

      it 'configures enabled_share_protocols' do
        is_expected.to contain_manila_config('DEFAULT/enabled_share_protocols').with_value('NFS')
      end
    end

    context 'enabled_share_protocols is set by array' do
      let :params do
        req_params.merge!({
          :enabled_share_protocols => ['NFS', 'CIFS']
        })
      end

      it 'configures enabled_share_protocols' do
        is_expected.to contain_manila_config('DEFAULT/enabled_share_protocols').with_value('NFS,CIFS')
      end
    end

    context 'admin_only_metadata is set' do
      let :params do
        req_params.merge!({
          :admin_only_metadata => ['__affinity_same_host', '__affinity_different_host']
        })
      end

      it 'configures enabled_share_protocols' do
        is_expected.to contain_manila_config('DEFAULT/admin_only_metadata').with_value(
          '__affinity_same_host,__affinity_different_host'
        )
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

      it_behaves_like 'manila::api'
    end
  end
end
