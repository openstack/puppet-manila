Puppet::Type.newtype(:manila_type) do

  desc 'Type for managing manila types.'

  ensurable

  newparam(:name, :namevar => true) do
    newvalues(/\S+/)
  end

  newparam(:is_public, :boolean => true) do
    desc 'Whether the type is public or not. Default to `true`'
    newvalues(:true, :false)
    defaultto true
  end

  newparam(:driver_handles_share_servers, :boolean => true) do
    desc 'Whether the driver handles share servers. Default to `false`'
    newvalues(:true, :false)
    defaultto false
  end

  newparam(:snapshot_support, :boolean => true) do
    desc 'Filter backends by their capability to create share snapshots'
    newvalues(:true, :false)
    defaultto false
  end

  newparam(:create_share_from_snapshot_support, :boolean => true) do
    desc 'Filter backends by their capability to create shares from snapshots.'
    newvalues(:true, :false)
    defaultto false
  end

  newparam(:revert_to_snapshot_support, :boolean => true) do
    desc 'Filter backends by their capability to revert shares to snapshots.'
    newvalues(:true, :false)
    defaultto false
  end

  newparam(:mount_snapshot_support, :boolean => true) do
    desc 'Filter backends by their capability to mount share snapshots.'
    newvalues(:true, :false)
    defaultto false
  end

  autorequire(:anchor) do
    ['manila::service::end']
  end
end
