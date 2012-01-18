# This has to be a separate type to enable collecting
Puppet::Type.newtype(:postgresql_database) do
  @doc = "Manage a database database."

  ensurable
  autorequire(:service) { 'postgresql' }

  newparam(:name) do
    desc "The name of the database."
  end
  newparam(:owner) do
    desc "Which user is the superuser for this database."
  end
end
