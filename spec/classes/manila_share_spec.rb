require 'spec_helper'

describe 'manila::share' do

  let :pre_condition do
    'class { "manila": rabbit_password => "fpp", sql_connection => "mysql://a:b@c/d" }'
  end

  let :facts do
    {:osfamily => 'Debian'}
  end

  it { should contain_package('manila-share').with_ensure('present') }
  it { should contain_service('manila-share').with(
      'hasstatus' => true
  )}

  describe 'with manage_service false' do
    let :params do
      { 'manage_service' => false }
    end
    it 'should not change the state of the service' do
      should contain_service('manila-share').without_ensure
    end
  end
end
