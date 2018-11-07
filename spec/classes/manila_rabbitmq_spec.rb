require 'spec_helper'

describe 'manila::rabbitmq' do

  shared_examples_for 'manila::rabbitmq' do
    context 'with defaults' do

      it 'should contain all of the default resources' do

        is_expected.to contain_rabbitmq_vhost('/').with(
          :provider => 'rabbitmqctl'
        )
      end

    end

    context 'when a rabbitmq user is specified' do

      let :params do
        {
          :userid   => 'dan',
          :password => 'pass'
        }
      end

      it 'should contain user and permissions' do

        is_expected.to contain_rabbitmq_user('dan').with(
          :admin    => true,
          :password => 'pass',
          :provider => 'rabbitmqctl'
        )

        is_expected.to contain_rabbitmq_user_permissions('dan@/').with(
          :configure_permission => '.*',
          :write_permission     => '.*',
          :read_permission      => '.*',
          :provider             => 'rabbitmqctl'
        )

      end

    end

    context 'when disabled' do
      let :params do
        {
          :userid   => 'dan',
          :password => 'pass',
          :enabled  => false
        }
      end

      it 'should be disabled' do

        is_expected.to_not contain_rabbitmq_user('dan')
        is_expected.to_not contain_rabbitmq_user_permissions('dan@/')
        is_expected.to_not contain_rabbitmq_vhost('/')

      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :fqdn => 'some.host.tld'}))
      end
      it_behaves_like 'manila::rabbitmq'
    end
  end

end
