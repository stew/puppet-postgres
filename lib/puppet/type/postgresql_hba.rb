# This has to be a separate type to enable collecting
Puppet::Type.newtype(:postgresql_hba) do
  @doc = "Manage a database user."

  ensurable
  autorequire(:service) { 'postgresql' }

  newparam(:type) do
    desc "The name of the user."
  end

  newparam(:custer) do
    desc "The title of the cluster this applies to."
  end

  newparam(:address) do
    desc "The address the user is alloed to connect from as a hostname or ip or network in CIDR notation."
  end

  newparam(:database) do
    desc "The database the user is allowed to connect to (or 'all')."
  end

  newparam(:user) do
    desc "The user that is allowed to connect (or 'all')."
  end

  newparam(:method) do
    desc "(trust|reject|md5|password|gss|sspi|krb5|ident|ldap|cert|pam)."
  end

  newparam(:options) do
    desc "Should this user be able to create other roles."
  end
end
