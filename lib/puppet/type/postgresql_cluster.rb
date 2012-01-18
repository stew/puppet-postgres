Puppet::Type.newtype(:postgresql_cluster) do

  @doc = "Manage a database cluster."
  ensurable
  autorequire(:service) { 'postgresql' }

  newparam(:name) do
    desc "The name of the cluster."
  end

  newparam(:version) do
    desc "The postgres major version of this cluster."
  end

  newparam(:port) do
    desc "Which tcp port does this cluster listen on."
  end

  newparam(:owner) do
    desc "Which user is the superuser for this cluster."
  end

  newparam(:datadir) do
    desc "Where is data stored for this cluster."
  end

  newparam(:logfile) do
    desc "Where is the logfile for this cluster."
  end

  newparam(:encoding) do
    desc "What is the default encoding for this cluster."
  end

  newparam(:socketdir) do
    desc "Where is the socket for this cluster located."
  end

end
