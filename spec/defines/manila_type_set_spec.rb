#Author: Andrew Woodward <awoodward@mirantis.com>

require 'spec_helper'

describe 'manila::type_set' do

  shared_examples_for 'manila types' do

    let(:title) {'hippo'}

    let :params do
      {
        :type           => 'sith',
        :key            => 'monchichi',
        :os_password    => 'asdf',
        :os_tenant_name => 'admin',
        :os_username    => 'admin',
        :os_auth_url    => 'http://127.127.127.1:5000/v3/',
      }
    end

    it 'should have its execs' do
      is_expected.to contain_exec('manila type-key sith set monchichi=hippo').with(
        :command => 'manila type-key sith set monchichi=hippo',
        :environment => [
          'OS_TENANT_NAME=admin',
          'OS_USERNAME=admin',
          'OS_PASSWORD=asdf',
          'OS_AUTH_URL=http://127.127.127.1:5000/v3/'],
        :require => 'Anchor[manila::install::end]')
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'manila types'
    end
  end
end
