require 'puppet/provider/package'

Puppet::Type.type(:postgresql_user).
  provide(:postgresql, :parent => Puppet::Provider::Package) do

  def self.instances
    groups = []

    cmd = ["/usr/bin/psql", "-Atc", "\\dg"]
    out = execute(cmd, {:uid => "postgres"})
    out.split("\n").each do |line|
      groups << new( query_line_to_hash(line) )
    end
    return groups
  end

  def self.query_line_to_hash(line)
    fields = line.chomp.split(/|/)
    {
      :name => fields[0],
      :ensure => :present
    }
  end

  def create
    cmd = ["/usr/bin/psql", "-Atc", "create group %s" % @resource[:name]]
    execute(cmd, {:uid => "postgres", :failonfail => true})
  end

  def destroy
    cmd = ["/usr/bin/psql", "-Atc", "drop group %s" % @resource[:name]]
    execute(cmd, {:uid => "postgres", :failonfail => true})
  end

  def exists?
    cmd = ["/usr/bin/psql", "-Atc", "\\dg %s" % @resource[:name]]
    out = execute(cmd, {:uid => "postgres", :failonfail => true, :combine => true})
    m = /^([^|]*)\|/.match(out)
    m && (m[1] == @resource[:name])
  end
    
end
