require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/manila')

Puppet::Type.type(:manila_type).provide(
  :openstack,
  :parent => Puppet::Provider::Manila
) do

  desc 'Provider for manila types.'

  @credentials = Puppet::Provider::Openstack::CredentialsV3.new

  mk_resource_methods

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def self.do_not_manage
    @do_not_manage
  end

  def self.do_not_manage=(value)
    @do_not_manage = value
  end

  def create
    if self.class.do_not_manage
      fail("Not managing Manila_type[#{@resource[:name]}] due to earlier Manila API failures.")
    end
    opts = [@resource[:name]]
    opts << @resource[:driver_handles_share_servers].to_s.capitalize
    opts << '--public' << @resource[:is_public].to_s.capitalize
    opts << '--snapshot-support' << @resource[:snapshot_support].to_s.capitalize
    opts << '--create-share-from-snapshot-support' << @resource[:create_share_from_snapshot_support].to_s.capitalize
    opts << '--revert-to-snapshot-support' << @resource[:revert_to_snapshot_support].to_s.capitalize
    opts << '--mount-snapshot-support' << @resource[:mount_snapshot_support].to_s.capitalize

    self.class.system_request('share type', 'create', opts)

    [
      :name,
      :is_public,
      :driver_handles_share_servers,
      :snapshot_support,
      :create_share_from_snapshot_support,
      :revert_to_snapshot_support,
      :mount_snapshot_support
    ].each do |attr|
      @property_hash[attr] = @resource[attr]
    end
    @property_hash[:ensure] = :present
  end

  def destroy
    if self.class.do_not_manage
      fail("Not managing Manila_type[#{@resource[:name]}] due to earlier Manila API failures.")
    end
    self.class.system_request('share type', 'delete', name)
    @property_hash.clear
    @property_hash[:ensure] = :absent
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def self.parse_specs(specs)
    JSON.parse(specs.gsub(/'/, '"'))
  end

  def self.instances
    self.do_not_manage = true
    list = system_request('share type', 'list').collect do |type|
      required_extra_specs = self.parse_specs(type[:required_extra_specs])
      optional_extra_specs = self.parse_specs(type[:optional_extra_specs])

      new({
        :name                               => type[:name],
        :ensure                             => :present,
        :id                                 => type[:id],
        :is_public                          => (type[:visibility] == 'public'),
        :driver_handles_share_servers       => (required_extra_specs['driver_handles_share_servers'] == 'True'),
        :snapshot_support                   => (optional_extra_specs['snapshot_support'] == 'True'),
        :create_share_from_snapshot_support => (optional_extra_specs['create_share_from_snapshot_support'] == 'True'),
        :revert_to_snapshot_support         => (optional_extra_specs['revert_to_snapshot_support'] == 'True'),
        :mount_snapshot_support             => (optional_extra_specs['mount_snapshot_support'] == 'True'),
      })
    end
    self.do_not_manage = false
    list
  end

  def self.prefetch(resources)
    types = instances
    resources.keys.each do |name|
      if provider = types.find{ |type| type.name == name }
        resources[name].provider = provider
      end
    end
  end

  def flush
    if !@property_flush.empty?
      opts = [@resource[:name]]

      if @property_flush.has_key?(:is_public)
        opts << '--public' << @property_flush[:is_public].to_s.capitalize
      end

      if @property_flush.has_key?(:snapshot_support)
        opts << '--snapshot-support' << @property_flush[:snapshot_support].to_s.capitalize
      end

      if @property_flush.has_key?(:create_share_from_snapshot_support)
        opts << '--create-share-from-snapshot-support' << @property_flush[:create_share_from_snapshot_support].to_s.capitalize
      end

      if @property_flush.has_key?(:revert_to_snapshot_support)
        opts << '--revert-to-snapshot-support' << @property_flush[:revert_to_snapshot_support].to_s.capitalize
      end

      if @property_flush.has_key?(:mount_snapshot_support)
        opts << '--mount-snapshot-support' << @property_flush[:mount_snapshot_support].to_s.capitalize
      end

      self.class.system_request('share type', 'set', opts)
      @property_flush.clear
    end
  end

  [
    :is_public,
    :snapshot_support,
    :create_share_from_snapshot_support,
    :revert_to_snapshot_support,
    :mount_snapshot_support
  ].each do |attr|
    define_method(attr.to_s + "=") do |value|
      if self.class.do_not_manage
        fail("Not managing Manila_type[#{@resource[:name]}] due to earlier Manila API failures.")
      end
      @property_flush[attr] = value
    end
  end

  [
    :driver_handles_share_servers,
  ].each do |attr|
    define_method(attr.to_s + "=") do |value|
      fail("Property #{attr.to_s} does not support being updated")
    end
  end
end
