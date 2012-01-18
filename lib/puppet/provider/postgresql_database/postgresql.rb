require 'puppet/provider/package'

Puppet::Type.type(:postgresql_user).
  provide(:postgresql, :parent => Puppet::Provider::Package) do

  def self.instances
    groups = []

    cmd = ["/usr/bin/psql", "-Atc", "select * from pg_database"]
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
    cmd = ["createdb"]

    if @resource[:owner] then
      cmd << "-O" << @resource[:owner]
    end

    cmd << @resource[:name]
    execute(cmd, {:uid => "postgres", :failonfail => true})
  end

  def destroy
    cmd = ["dropdb"]
    cmd << @resource[:name]
    execute(cmd, {:uid => "postgres", :failonfail => true})
  end

  def exists?
    cmd = ["/usr/bin/psql", "-Atc", "select * from pg_database where datname='%s'" % @resource[:name]]
    out = execute(cmd, {:uid => "postgres", :failonfail => true, :combine => true})
    m = /^([^|]*)\|/.match(out)
    m && (m[1] == @resource[:name])
  end

end
