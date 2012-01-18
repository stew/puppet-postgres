# This has to be a separate type to enable collecting
Puppet::Type.newtype(:postgresql_group) do
  @doc = "Manage a database group."

  ensurable
  autorequire(:service) { 'postgresql' }

  newparam(:name) do
    desc "The name of the group."
  end
end
