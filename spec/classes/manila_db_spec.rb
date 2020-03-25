require 'spec_helper'

describe 'manila::db' do
  shared_examples 'manila::db' do
    context 'with default parameters' do
      it { should contain_class('manila::deps') }

      it { should contain_oslo__db('manila_config').with(
        :db_max_retries          => '<SERVICE DEFAULT>',
        :connection              => 'sqlite:////var/lib/manila/manila.sqlite',
        :connection_recycle_time => '<SERVICE DEFAULT>',
        :max_pool_size           => '<SERVICE DEFAULT>',
        :max_retries             => '<SERVICE DEFAULT>',
        :retry_interval          => '<SERVICE DEFAULT>',
        :max_overflow            => '<SERVICE DEFAULT>',
        :pool_timeout            => '<SERVICE DEFAULT>',
      )}
    end

    context 'with specific parameters' do
      let :params do
        {
          :database_connection              => 'mysql+pymysql://manila:manila@localhost/manila',
          :database_connection_recycle_time => '3601',
          :database_max_pool_size           => '21',
          :database_max_retries             => '11',
          :database_max_overflow            => '21',
          :database_pool_timeout            => '21',
          :database_retry_interval          => '11',
          :database_db_max_retries          => '-1',
        }
      end

      it { should contain_class('manila::deps') }

      it { should contain_oslo__db('manila_config').with(
        :db_max_retries          => '-1',
        :connection              => 'mysql+pymysql://manila:manila@localhost/manila',
        :connection_recycle_time => '3601',
        :max_pool_size           => '21',
        :max_retries             => '11',
        :retry_interval          => '11',
        :max_overflow            => '21',
        :pool_timeout            => '21',
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :fqdn => 'some.host.tld'}))
      end

      it_behaves_like 'manila::db'
    end
  end
end
