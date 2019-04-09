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

  let :facts do
    @default_facts.merge({
      :osfamily               => 'Debian',
      :operatingsystem        => 'Debian',
      :operatingsystemrelease => 'jessie'
     })
  end

  describe 'with only required params' do
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
      is_expected.to contain_manila_config('oslo_middleware/enable_proxy_headers_parsing').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_manila_config('DEFAULT/default_share_type').with(:value => '<SERVICE DEFAULT>')
      is_expected.to contain_manila_config('DEFAULT/osapi_share_workers').with(:value => '2')
    end

    it 'should run db sync' do
      is_expected.to contain_class('manila::db::sync')
    end
  end

  describe 'with a default share type' do
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

  describe 'with service workers' do
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

  describe 'with only required params' do
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

  describe 'with only required params' do
    let :params do
      req_params.merge({'enable_proxy_headers_parsing' => true})
    end
    it { is_expected.to contain_class('manila::policy') }
    it 'should configure manila api correctly' do
      is_expected.to contain_manila_config('oslo_middleware/enable_proxy_headers_parsing').with(
       :value => true
      )
    end
  end

  describe 'with enabled false' do
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

  describe 'with sync_db false' do
    let :params do
      req_params.merge({'sync_db' => false})
    end
    it { is_expected.to contain_class('manila::policy') }
    it 'should not include manila::db::sync' do
      is_expected.to_not contain_class('manila::db::sync')
    end
  end

  describe 'with manage_service false' do
    let :params do
      req_params.merge({'manage_service' => false})
    end
    it { is_expected.to contain_class('manila::policy') }
    it 'should not change the state of the service' do
      is_expected.to contain_service('manila-api').without_ensure
    end
  end

  describe 'with ratelimits' do
    let :params do
      req_params.merge({ :ratelimits => '(GET, "*", .*, 100, MINUTE);(POST, "*", .*, 200, MINUTE)' })
    end

    it { is_expected.to contain_class('manila::policy') }
    it { is_expected.to contain_manila_api_paste_ini('filter:ratelimit/limits').with(
      :value => '(GET, "*", .*, 100, MINUTE);(POST, "*", .*, 200, MINUTE)'
    )}
  end

  describe 'when running manila-api in wsgi' do
      let :params do
        req_params.merge!({ :service_name => 'httpd' })
      end

      let :pre_condition do
        "include ::apache
         class { 'manila': }
         class { '::manila::keystone::authtoken':
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

    describe 'when service_name is not valid' do
      let :params do
        req_params.merge!({ :service_name => 'foobar' })
      end

      let :pre_condition do
        "include ::apache
         class { 'manila': }
         class { '::manila::keystone::authtoken':
           password => 'foo',
         }"
      end

      it_raises 'a Puppet::Error', /Invalid service_name/
    end

end
