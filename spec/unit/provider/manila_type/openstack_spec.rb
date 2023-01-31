require 'puppet'
require 'puppet/provider/manila_type/openstack'

provider_class = Puppet::Type.type(:manila_type).provider(:openstack)

describe provider_class do

  let(:set_creds_env) do
    ENV['OS_USERNAME']     = 'test'
    ENV['OS_PASSWORD']     = 'abc123'
    ENV['OS_PROJECT_NAME'] = 'test'
    ENV['OS_AUTH_URL']     = 'http://127.0.0.1:5000'
  end

  let(:type_attributes) do
    {
      :name                               => 'test_type',
      :ensure                             => :present,
      :is_public                          => true,
      :driver_handles_share_servers       => false,
      :snapshot_support                   => false,
      :create_share_from_snapshot_support => false,
      :revert_to_snapshot_support         => false,
      :mount_snapshot_support             => false,
    }
  end

  let(:resource) do
    Puppet::Type::Manila_type.new(type_attributes)
  end

  let(:provider) do
    provider_class.new(resource)
  end

  before(:each) { set_creds_env }

  after(:each) do
    Puppet::Type.type(:manila_type).provider(:openstack).reset
    provider_class.reset
  end

  describe 'managing type' do
    describe '#create' do
      context 'with defaults' do
        it 'creates a type' do
          expect(provider_class).to receive(:openstack)
            .with('share type', 'create', '--format', 'shell',
                  ['test_type', 'False', '--public', 'True',
                   '--snapshot-support', 'False',
                   '--create-share-from-snapshot-support', 'False',
                   '--revert-to-snapshot-support', 'False',
                   '--mount-snapshot-support', 'False'])
            .and_return('id="90e19aff-1b35-4d60-9ee3-383c530275ab"
name="test_type"
visibility="public"
required_extra_specs="{\'driver_handles_share_servers\': \'False\'}"
optional_extra_specs="{\'snapshot_support\': \'False\', \'create_share_from_snapshot_support\': \'False\', \'revert_to_snapshot_support\': \'False\', \'mount_snapshot_support\': \'False\'}"
description="None"
')
          provider.create
          expect(provider.exists?).to be_truthy
        end
      end
    end

    describe '#instances' do
      it 'finds types' do
        expect(provider_class).to receive(:openstack)
          .with('share type', 'list', '--quiet', '--format', 'csv', [])
          .and_return('"ID","Name","Visibility","Is Default","Required Extra Specs","Optional Extra Specs","Description"
"90e19aff-1b35-4d60-9ee3-383c530275ab","type0","public","False","{\'driver_handles_share_servers\': \'True\'}","{\'snapshot_support\': \'True\'}",""
"90e19aff-1b35-4d60-9ee3-383c530275ab","type1","private","False","{\'driver_handles_share_servers\': \'False\'}","{}",""
')
        instances = provider_class.instances
        expect(instances.count).to eq(2)

        expect(instances[0].name).to eq('type0')
        expect(instances[0].is_public).to be true
        expect(instances[0].driver_handles_share_servers).to be true
        expect(instances[0].snapshot_support).to be true
        expect(instances[0].create_share_from_snapshot_support).to be false
        expect(instances[0].revert_to_snapshot_support).to be false
        expect(instances[0].mount_snapshot_support).to be false

        expect(instances[1].name).to eq('type1')
        expect(instances[1].is_public).to be false
        expect(instances[1].driver_handles_share_servers).to be false
        expect(instances[1].snapshot_support).to be false
        expect(instances[1].create_share_from_snapshot_support).to be false
        expect(instances[1].revert_to_snapshot_support).to be false
        expect(instances[1].mount_snapshot_support).to be false
      end
    end

    describe '#flush' do
      context '.is_public' do
        it 'updates type' do
          expect(provider_class).to receive(:openstack)
            .with('share type', 'set', ['test_type', '--public', 'False'])
          provider.is_public = false
          provider.flush

          expect(provider_class).to receive(:openstack)
            .with('share type', 'set', ['test_type', '--public', 'True'])
          provider.is_public = true
          provider.flush
        end
      end

      context '.snapshot_support' do
        it 'updates type' do
          expect(provider_class).to receive(:openstack)
            .with('share type', 'set', ['test_type', '--snapshot-support', 'False'])
          provider.snapshot_support = false
          provider.flush

          expect(provider_class).to receive(:openstack)
            .with('share type', 'set', ['test_type', '--snapshot-support', 'True'])
          provider.snapshot_support = true
          provider.flush
        end
      end
    end

    describe '#destroy' do
      it 'destroys a type' do
        expect(provider_class).to receive(:openstack)
          .with('share type', 'delete', 'test_type')
        provider.destroy
        expect(provider.exists?).to be_falsey
      end
    end
  end
end
