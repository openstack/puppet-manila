require 'puppet'
require 'puppet/type/manila_type'

describe Puppet::Type.type(:manila_type) do

  before :each do
    Puppet::Type.rmtype(:manila_type)
  end

  it 'should autorequire manila-api service' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'manila::service::end')
    correct_input = {
      :name => 'test_type',
    }
    manila_type = Puppet::Type.type(:manila_type).new(correct_input)

    catalog.add_resource anchor, manila_type
    dependency = manila_type.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(manila_type)
    expect(dependency[0].source).to eq(anchor)
  end
end
