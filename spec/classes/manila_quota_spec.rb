require 'spec_helper'

describe 'manila::quota' do

  shared_examples_for 'manila::quota' do
    context 'with default parameters' do
      it 'contains default values' do
        is_expected.to contain_manila_config('quota/shares').with(
          :value => '<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('quota/snapshots').with(
          :value => '<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('quota/gigabytes').with(
          :value => '<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('quota/per_share_gigabytes').with(
          :value => '<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('quota/snapshot_gigabytes').with(
          :value => '<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('quota/share_networks').with(
          :value => '<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('quota/share_replicas').with(
          :value => '<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('quota/replica_gigabytes').with(
          :value => '<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('quota/backups').with(
          :value => '<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('quota/backup_gigabytes').with(
          :value => '<SERVICE DEFAULT>')

        is_expected.to contain_manila_config('quota/driver').with(
          :value => '<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('quota/reservation_expire').with(
          :value => '<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('quota/until_refresh').with(
          :value => '<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('quota/max_age').with(
          :value => '<SERVICE DEFAULT>')
      end
    end

    context 'with overridden parameters' do
      let :params do
        { :shares              => 1000,
          :snapshots           => 1001,
          :gigabytes           => 100000,
          :per_share_gigabytes => -1,
          :snapshot_gigabytes  => 10000,
          :share_networks      => 100,
          :share_replicas      => 10,
          :replica_gigabytes   => 100,
          :backups             => 1002,
          :backup_gigabytes    => 101,
          :driver              => 'manila.quota.DbQuotaDriver',
          :reservation_expire  => 864000,
          :until_refresh       => 10,
          :max_age             => 10,
        }
      end
      it 'contains overridden values' do
        is_expected.to contain_manila_config('quota/shares').with(
          :value => 1000)
        is_expected.to contain_manila_config('quota/snapshots').with(
          :value => 1001)
        is_expected.to contain_manila_config('quota/gigabytes').with(
          :value => 100000)
        is_expected.to contain_manila_config('quota/per_share_gigabytes').with(
          :value => -1)
        is_expected.to contain_manila_config('quota/snapshot_gigabytes').with(
          :value => 10000)
        is_expected.to contain_manila_config('quota/share_networks').with(
          :value => 100)
        is_expected.to contain_manila_config('quota/share_replicas').with(
          :value => 10)
        is_expected.to contain_manila_config('quota/replica_gigabytes').with(
          :value => 100)
        is_expected.to contain_manila_config('quota/backups').with(
          :value => 1002)
        is_expected.to contain_manila_config('quota/backup_gigabytes').with(
          :value => 101)

        is_expected.to contain_manila_config('quota/driver').with(
          :value => 'manila.quota.DbQuotaDriver')
        is_expected.to contain_manila_config('quota/reservation_expire').with(
          :value => 864000)
        is_expected.to contain_manila_config('quota/until_refresh').with(
          :value => 10)
        is_expected.to contain_manila_config('quota/max_age').with(
          :value => 10)
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end
      it_behaves_like 'manila::quota'
    end
  end

end
