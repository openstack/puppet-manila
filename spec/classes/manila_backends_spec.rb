#
# Copyright (C) 2014 eNovance SAS <licensing@enovance.com>
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
# Unit tests for manila::backends class
#

require 'spec_helper'

describe 'manila::backends' do

  let :default_params do
    {}
  end

  let :params do
    {}
  end

  shared_examples_for 'manila backends' do

    let :p do
      default_params.merge(params)
    end

    context 'with enabled_share_backends set by string' do
      before :each do
        params.merge!(
         :enabled_share_backends => 'lowcost,regular,premium'
        )
      end

      it 'configures manila.conf with default params' do
        is_expected.to contain_manila_config('DEFAULT/enabled_share_backends').with_value(p[:enabled_share_backends])
      end
    end

    context 'with enabled_share_backends set by array' do
      before :each do
        params.merge!(
         :enabled_share_backends => ['lowcost', 'regular', 'premium']
        )
      end

      it 'configures manila.conf with default params' do
        is_expected.to contain_manila_config('DEFAULT/enabled_share_backends').with_value(p[:enabled_share_backends].join(','))
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
      it_behaves_like 'manila backends'
    end
  end
end
