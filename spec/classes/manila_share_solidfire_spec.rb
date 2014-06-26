require 'spec_helper'

describe 'manila::share::solidfire' do
  let :req_params do
    {
      :san_ip       => '127.0.0.2',
      :san_login    => 'solidfire',
      :san_password => 'password',
    }
  end

  let :params do
    req_params
  end

  describe 'solidfire share driver' do
    it 'configure solidfire share driver' do
      should contain_manila_config('DEFAULT/share_driver').with_value(
        'manila.share.drivers.solidfire.SolidFire')
      should contain_manila_config('DEFAULT/san_ip').with_value(
        '127.0.0.2')
      should contain_manila_config('DEFAULT/san_login').with_value(
        'solidfire')
      should contain_manila_config('DEFAULT/san_password').with_value(
        'password')
    end
  end
end
