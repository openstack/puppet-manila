require 'spec_helper'

describe 'manila::wsgi::apache' do

  shared_examples_for 'apache serving manila with mod_wsgi' do
    context 'with default parameters' do
      it { is_expected.to contain_class('manila::params') }
      it { is_expected.to contain_openstacklib__wsgi__apache('manila_wsgi').with(
        :bind_port                   => 8786,
        :group                       => 'manila',
        :path                        => '/',
        :servername                  => facts[:fqdn],
        :ssl                         => false,
        :threads                     => 1,
        :user                        => 'manila',
        :workers                     => facts[:os_workers],
        :wsgi_daemon_process         => 'manila-api',
        :wsgi_process_group          => 'manila-api',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'manila-api',
        :wsgi_script_source          => platform_params[:wsgi_script_source],
        :custom_wsgi_process_options => {},
        :access_log_file             => false,
        :access_log_format           => false,
      )}
    end

    context'when overriding parameters using different ports' do
      let :params do
        {
          :servername                  => 'dummy.host',
          :bind_host                   => '10.42.51.1',
          :port                        => 12345,
          :ssl                         => true,
          :wsgi_process_display_name   => 'manila-api',
          :workers                     => 37,
          :custom_wsgi_process_options => {
            'python_path' => '/my/python/admin/path',
          },
          :access_log_file             => '/var/log/httpd/access_log',
          :access_log_format           => 'some format',
          :error_log_file              => '/var/log/httpd/error_log',
          :vhost_custom_fragment       => 'Timeout 99'
        }
      end
      it { is_expected.to contain_class('manila::params') }
      it { is_expected.to contain_openstacklib__wsgi__apache('manila_wsgi').with(
        :bind_host                 => '10.42.51.1',
        :bind_port                 => 12345,
        :group                     => 'manila',
        :path                      => '/',
        :servername                => 'dummy.host',
        :ssl                       => true,
        :threads                   => 1,
        :user                      => 'manila',
        :vhost_custom_fragment     => 'Timeout 99',
        :workers                   => 37,
        :wsgi_daemon_process       => 'manila-api',
        :wsgi_process_display_name => 'manila-api',
        :wsgi_process_group        => 'manila-api',
        :wsgi_script_dir           => platform_params[:wsgi_script_path],
        :wsgi_script_file          => 'manila-api',
        :wsgi_script_source        => platform_params[:wsgi_script_source],
        :custom_wsgi_process_options => {
          'python_path'  => '/my/python/admin/path',
        },
        :access_log_file           => '/var/log/httpd/access_log',
        :access_log_format         => 'some format',
        :error_log_file            => '/var/log/httpd/error_log'
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers     => 42,
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld',
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          {
            :wsgi_script_path   => '/usr/lib/cgi-bin/manila',
            :wsgi_script_source => '/usr/bin/manila-wsgi'
          }
        when 'RedHat'
          {
            :wsgi_script_path   => '/var/www/cgi-bin/manila',
            :wsgi_script_source => '/usr/bin/manila-wsgi'
          }
        end
      end

      it_behaves_like 'apache serving manila with mod_wsgi'
    end
  end
end
