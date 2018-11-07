require 'spec_helper'

describe 'manila::db' do

  shared_examples 'manila::db' do

    context 'with default parameters' do

      it { is_expected.to contain_oslo__db('manila_config').with(
        :db_max_retries => '<SERVICE DEFAULT>',
        :connection     => 'sqlite:////var/lib/manila/manila.sqlite',
        :idle_timeout   => '<SERVICE DEFAULT>',
        :min_pool_size  => '<SERVICE DEFAULT>',
        :max_pool_size  => '<SERVICE DEFAULT>',
        :max_retries    => '<SERVICE DEFAULT>',
        :retry_interval => '<SERVICE DEFAULT>',
        :max_overflow   => '<SERVICE DEFAULT>',
        :pool_timeout   => '<SERVICE DEFAULT>',
      )}

    end

    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mysql+pymysql://manila:manila@localhost/manila',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_pool_size  => '21',
          :database_max_retries    => '11',
          :database_max_overflow   => '21',
          :database_pool_timeout   => '21',
          :database_retry_interval => '11',
          :database_db_max_retries => '-1', }
      end

      it { is_expected.to contain_oslo__db('manila_config').with(
        :db_max_retries => '-1',
        :connection     => 'mysql+pymysql://manila:manila@localhost/manila',
        :idle_timeout   => '3601',
        :min_pool_size  => '2',
        :max_pool_size  => '21',
        :max_retries    => '11',
        :retry_interval => '11',
        :max_overflow   => '21',
        :pool_timeout   => '21',
      )}

    end

    context 'with MySQL-python library as backend package' do
      let :params do
        { :database_connection => 'mysql://manila:manila@localhost/manila' }
      end

      it { is_expected.to contain_oslo__db('manila_config').with(
        :connection => 'mysql://manila:manila@localhost/manila',
      )}
    end

    context 'with postgresql backend' do
      let :params do
        { :database_connection => 'postgresql://manila:manila@localhost/manila', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end

    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection => 'redis://manila:manila@localhost/manila', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection => 'foo+pymysql://manila:manila@localhost/manila', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

  end

  shared_examples_for 'manila::db on Debian' do
    context 'using pymysql driver' do
      let :params do
        { :database_connection => 'mysql+pymysql://manila:manila@localhost/manila' }
      end

      it { is_expected.to contain_package('python-pymysql').with({ :ensure => 'present', :name => 'python-pymysql', :tag=> 'openstack' }) }
    end
  end

  shared_examples_for 'manila::db on RedHat' do
    context 'using pymysql driver' do
      let :params do
        { :database_connection => 'mysql+pymysql://manila:manila@localhost/manila' }
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
      it_behaves_like 'manila::db'
      it_behaves_like "manila::db on #{facts[:osfamily]}"
    end
  end

end
