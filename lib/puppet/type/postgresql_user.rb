# This has to be a separate type to enable collecting
Puppet::Type.newtype(:postgresql_user) do
  @doc = "Manage a database user."

  ensurable
  autorequire(:service) { 'postgresql' }

  newparam(:name) do
    desc "The name of the user."
  end

  newparam(:superuser) do
    desc "Should this user be a superuser."
  end

  newparam(:createdb) do
    desc "Should this user be able to create databases."
  end

  newparam(:createrole) do
    desc "Should this user be able to create other roles."
  end
end
