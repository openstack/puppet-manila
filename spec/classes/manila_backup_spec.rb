#
# Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# Unit tests for manila::backup class
#

require 'spec_helper'

describe 'manila::backup' do

  let :default_params do
    { :enable               => true,
      :backup_topic         => 'manila-backup',
      :backup_manager       => 'manila.backup.manager.BackupManager',
      :backup_api_class     => 'manila.backup.api.API',
      :backup_name_template => 'backup-%s' }
  end

  let :params do
    {}
  end

  shared_examples_for 'manila backup' do
    let :p do
      default_params.merge(params)
    end

    it { should contain_class('manila::params') }

    it 'installs manila backup package' do
      if platform_params.has_key?(:backup_package)
        should contain_package('manila-backup').with(
          :name   => platform_params[:backup_package],
          :ensure => 'present'
        )
        should contain_package('manila-backup').with_before(/Manila_config\[.+\]/)
        should contain_package('manila-backup').with_before(/Service\[manila-backup\]/)
      end
    end

    it 'ensure manila backup service is running' do
      should contain_service('manila-backup').with('hasstatus' => true)
    end

    it 'configures manila.conf' do
      should contain_manila_config('DEFAULT/backup_topic').with_value(p[:backup_topic])
      should contain_manila_config('DEFAULT/backup_manager').with_value(p[:backup_manager])
      should contain_manila_config('DEFAULT/backup_api_class').with_value(p[:backup_api_class])
      should contain_manila_config('DEFAULT/backup_name_template').with_value(p[:backup_name_template])
    end

    context 'when overriding backup_name_template' do
      before :each do
        params.merge!(:backup_name_template => 'foo-bar-%s')
      end
      it 'should replace default parameter with new value' do
        should contain_manila_config('DEFAULT/backup_name_template').with_value(p[:backup_name_template])
      end
    end
  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :platform_params do
      { :backup_package => 'manila-backup',
        :backup_service => 'manila-backup' }
    end

    it_configures 'manila backup'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      { :backup_service => 'manila-backup' }
    end

    it_configures 'manila backup'
  end

end
