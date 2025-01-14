require 'spec_helper'

describe 'manila::scheduler::filter' do
  shared_examples 'manila::scheduler::filter' do


    context 'with defaults' do
      it 'contains default values' do
        is_expected.to contain_manila_config('DEFAULT/scheduler_default_filters').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/scheduler_default_weighers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/scheduler_default_share_group_filters').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/scheduler_default_extend_filters').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/pool_weight_multiplier').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('DEFAULT/capacity_weight_multiplier').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parmeters' do
      let :params do
        {
          :default_filters             => 'AvailabilityZoneFilter,CapacityFilter,CapabilitiesFilter',
          :default_weighers            => 'CapacityWeigher,GoodnessWeigher',
          :default_share_group_filters => 'AvailabilityZoneFilter,ConsistentSnapshotFilter',
          :default_extend_filters      => 'CapacityFilter,DriverFilter',
          :pool_weight_multiplier      => 1.0,
          :capacity_weight_multiplier  => 1.1,
        }
      end

      it 'contains overridden values' do
        is_expected.to contain_manila_config('DEFAULT/scheduler_default_filters').with_value(
          'AvailabilityZoneFilter,CapacityFilter,CapabilitiesFilter'
        )
        is_expected.to contain_manila_config('DEFAULT/scheduler_default_weighers').with_value(
          'CapacityWeigher,GoodnessWeigher'
        )
        is_expected.to contain_manila_config('DEFAULT/scheduler_default_share_group_filters').with_value(
          'AvailabilityZoneFilter,ConsistentSnapshotFilter'
        )
        is_expected.to contain_manila_config('DEFAULT/scheduler_default_extend_filters').with_value(
          'CapacityFilter,DriverFilter'
        )
        is_expected.to contain_manila_config('DEFAULT/pool_weight_multiplier').with_value(1.0)
        is_expected.to contain_manila_config('DEFAULT/capacity_weight_multiplier').with_value(1.1)
      end
    end

    context 'with parameters (array values)' do
      let :params do
        {
          :default_filters             => ['AvailabilityZoneFilter', 'CapacityFilter', 'CapabilitiesFilter'],
          :default_weighers            => ['CapacityWeigher', 'GoodnessWeigher'],
          :default_share_group_filters => ['AvailabilityZoneFilter', 'ConsistentSnapshotFilter'],
          :default_extend_filters      => ['CapacityFilter', 'DriverFilter'],
        }
      end

      it 'contains overridden values' do
        is_expected.to contain_manila_config('DEFAULT/scheduler_default_filters').with_value(
          'AvailabilityZoneFilter,CapacityFilter,CapabilitiesFilter'
        )
        is_expected.to contain_manila_config('DEFAULT/scheduler_default_weighers').with_value(
          'CapacityWeigher,GoodnessWeigher'
        )
        is_expected.to contain_manila_config('DEFAULT/scheduler_default_share_group_filters').with_value(
          'AvailabilityZoneFilter,ConsistentSnapshotFilter'
        )
        is_expected.to contain_manila_config('DEFAULT/scheduler_default_extend_filters').with_value(
          'CapacityFilter,DriverFilter'
        )
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'manila::scheduler::filter'
    end
  end
end
