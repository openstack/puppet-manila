require 'spec_helper'

describe 'manila::config' do
  let(:config_hash) do {
    'DEFAULT/foo' => { 'value'  => 'fooValue' },
    'DEFAULT/bar' => { 'value'  => 'barValue' },
    'DEFAULT/baz' => { 'ensure' => 'absent' }
  }
  end

  shared_examples 'manila_config' do
    let :params do
      { :manila_config => config_hash }
    end

    it { is_expected.to contain_class('manila::deps') }

    it 'configures arbitrary manila-config configurations' do
      is_expected.to contain_manila_config('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_manila_config('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_manila_config('DEFAULT/baz').with_ensure('absent')
    end
  end

  shared_examples 'manila_api_paste_ini' do
    let :params do
      { :api_paste_ini_config => config_hash }
    end

    it 'configures arbitrary manila-api-paste-ini configurations' do
      is_expected.to contain_manila_api_paste_ini('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_manila_api_paste_ini('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_manila_api_paste_ini('DEFAULT/baz').with_ensure('absent')
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'manila_config'
      it_behaves_like 'manila_api_paste_ini'
    end
  end
end
