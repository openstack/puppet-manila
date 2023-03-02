require 'spec_helper'

describe 'manila::params' do

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end
      it 'should compile' do
        subject
      end
    end
  end

end
