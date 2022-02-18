require 'puppet'
require 'spec_helper'
require 'puppet/provider/manila'
require 'tempfile'

klass = Puppet::Provider::Manila

describe Puppet::Provider::Manila do

  after :each do
    klass.reset
  end

  describe 'when retrieving the auth credentials' do

    it 'should fail if no auth params are passed and the manila config file does not have the expected contents' do
      mock = {}
      Puppet::Util::IniConfig::File.expects(:new).returns(mock)
      mock.expects(:read).with('/etc/manila/manila.conf')
      expect do
        klass.manila_credentials
      end.to raise_error(Puppet::Error, /Manila types will not work/)
    end

    it 'should read conf file with all sections' do
      creds_hash = {
        'auth_url'            => 'https://192.168.56.210:5000/v3/',
        'project_name'        => 'admin_tenant',
        'username'            => 'admin',
        'password'            => 'password',
        'project_domain_name' => 'Default',
        'user_domain_name'    => 'Default',
      }
      mock = {
        'keystone_authtoken' => {
          'auth_url'     => 'https://192.168.56.210:5000/v3/',
          'project_name' => 'admin_tenant',
          'username'     => 'admin',
          'password'     => 'password',
        }
      }
      Puppet::Util::IniConfig::File.expects(:new).returns(mock)
      mock.expects(:read).with('/etc/manila/manila.conf')
      expect(klass.manila_credentials).to eq(creds_hash)
    end

  end
end
