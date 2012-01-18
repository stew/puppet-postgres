require 'puppet/provider/package'

Puppet::Type.type(:postgresql_user).
  provide(:postgresql, :parent => Puppet::Provider::Package) do

  def self.instances
    users = []

    cmd = ["/usr/bin/psql", "-Atc", "\\du"]
    out = execute(cmd, {:uid => "postgres"})
    out.split("\n").each do |line|
      users << new( query_line_to_hash(line) )
    end
    return users
  end

  def self.query_line_to_hash(line)
    fields = line.chomp.split(/|/)
    {
      :name => fields[0],
      :roles => fields[1],
      :groups => fields[2],
      :ensure => :present
    }
  end
  
  def create
    cmd=["/usr/bin/createuser"]
    if @resource[:superuser] then
      cmd << "--superuser"
    else
      cmd << "--no-superuser"
      
      if @resource[:createdb] then
        cmd << "--createdb"
      else
        cmd << "--no-createdb"
      end
      
      if@resource[:createrole] then
        cmd << "--createrole"
      else
        cmd << "--no-createrole"
      end
    end
    cmd << @resource[:name]
    execute(cmd, {:uid => "postgres"})
  end

  def destroy
    cmd = ["/usr/bin/dropuser", @resource[:name]]
    execute(cmd, {:uid => "postgres"})
  end

  def exists?
    cmd = ["/usr/bin/psql", "-Atc", "\\du %s" % @resource[:name]]
    out = execute(cmd, {:uid => "postgres", :failonfail => true, :combine => false})
    m = /^([^|]*)\|/.match(out)
   m && (m[1] == @resource[:name])
  end
end
