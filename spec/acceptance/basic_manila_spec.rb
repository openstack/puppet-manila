require 'spec_helper_acceptance'

describe 'basic manila' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include openstack_integration
      include openstack_integration::repos
      include openstack_integration::apache
      include openstack_integration::rabbitmq
      include openstack_integration::mysql
      include openstack_integration::keystone

      rabbitmq_user { 'manila':
        admin    => true,
        password => 'an_even_bigger_secret',
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

      rabbitmq_user_permissions { 'manila@/':
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
        require              => Class['rabbitmq'],
      }

      # Manila resources
      class { 'manila::logging':
        debug => true,
      }
      class { 'manila':
        default_transport_url => 'rabbit://manila:an_even_bigger_secret@127.0.0.1:5672/',
        sql_connection        => 'mysql+pymysql://manila:a_big_secret@127.0.0.1/manila?charset=utf8',
      }
      class { 'manila::db::mysql':
        password => 'a_big_secret',
      }
      class { 'manila::keystone::auth':
        password    => 'a_big_secret',
        password_v2 => 'a_big_secret',
      }
      class { 'manila::client': }
      class { 'manila::compute::nova': }
      class { 'manila::network::neutron': }
      class { 'manila::volume::cinder': }
      class { 'manila::keystone::authtoken':
        password => 'a_big_secret',
      }
      class { 'manila::api':
        service_name        => 'httpd',
      }
      include apache
      class { 'manila::wsgi::apache':
        ssl => false,
      }
      class { 'manila::scheduler': }
      class { 'manila::cron::db_purge': }

      # missing: backends, share, service_instance
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe port(8786) do
      it { is_expected.to be_listening }
    end

    describe cron do
      it { is_expected.to have_entry('1 0 * * * manila-manage db purge 0 >>/var/log/manila/manila-rowsflush.log 2>&1').with_user('manila') }
    end
  end
end
