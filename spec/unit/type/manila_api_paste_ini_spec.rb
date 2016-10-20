require 'puppet'
require 'puppet/type/manila_api_paste_ini'

describe 'Puppet::Type.type(:manila_api_paste_ini)' do
  before :each do
    Puppet::Type.rmtype(:manila_api_paste_ini)
    Facter.fact(:osfamily).stubs(:value).returns(platform_params[:osfamily])
    @manila_api_paste_ini = Puppet::Type.type(:manila_api_paste_ini).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  shared_examples_for 'manila_api_paste_ini' do

    it 'should require a name' do
      expect {
        Puppet::Type.type(:manila_api_paste_ini).new({})
      }.to raise_error(Puppet::Error, 'Title or name must be provided')
    end

    it 'should not expect a name with whitespace' do
      expect {
        Puppet::Type.type(:manila_api_paste_ini).new(:name => 'f oo')
      }.to raise_error(Puppet::Error, /Parameter name failed/)
    end

    it 'should fail when there is no section' do
      expect {
        Puppet::Type.type(:manila_api_paste_ini).new(:name => 'foo')
      }.to raise_error(Puppet::Error, /Parameter name failed/)
    end

    it 'should not require a value when ensure is absent' do
      Puppet::Type.type(:manila_api_paste_ini).new(:name => 'DEFAULT/foo', :ensure => :absent)
    end

    it 'should accept a valid value' do
      @manila_api_paste_ini[:value] = 'bar'
      expect(@manila_api_paste_ini[:value]).to eq('bar')
    end

    it 'should not accept a value with whitespace' do
      @manila_api_paste_ini[:value] = 'b ar'
      expect(@manila_api_paste_ini[:value]).to eq('b ar')
    end

    it 'should accept valid ensure values' do
      @manila_api_paste_ini[:ensure] = :present
      expect(@manila_api_paste_ini[:ensure]).to eq(:present)
      @manila_api_paste_ini[:ensure] = :absent
      expect(@manila_api_paste_ini[:ensure]).to eq(:absent)
    end

    it 'should not accept invalid ensure values' do
      expect {
        @manila_api_paste_ini[:ensure] = :latest
      }.to raise_error(Puppet::Error, /Invalid value/)
    end

    it 'should autorequire the package that install the file' do
      catalog = Puppet::Resource::Catalog.new
      anchor = Puppet::Type.type(:anchor).new(:name => 'manila::install::end')
      catalog.add_resource anchor, @manila_api_paste_ini
      dependency = @manila_api_paste_ini.autorequire
      expect(dependency.size).to eq(1)
      expect(dependency[0].target).to eq(@manila_api_paste_ini)
      expect(dependency[0].source).to eq(anchor)
    end
  end

end

