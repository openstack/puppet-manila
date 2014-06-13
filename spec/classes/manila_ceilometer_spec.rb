require 'spec_helper'

describe 'manila::ceilometer' do

  describe 'with default parameters' do
    it 'contains default values' do
      should contain_manila_config('DEFAULT/notification_driver').with(
        :value => 'manila.openstack.common.notifier.rpc_notifier')
    end
  end
end
