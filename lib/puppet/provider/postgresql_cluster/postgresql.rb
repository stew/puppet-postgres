require 'puppet/provider/package'

Puppet::Type.type(:postgresql_cluster).
  provide(:postgresql, :parent => Puppet::Provider::Package) do

  def self.instances
    clusters = []
    cmd = ["/usr/bin/pg_lsclusters", "-h"]
    out = execute(cmd, {:uid => "postgres"})
    out.split("\n").each do |line|
      clusters << new( query_line_to_hash(line) )
    end
    return clusters
  end

  def self.query_line_to_hash(line)
    fields = line.chomp.split(/\s+/)
    {
      :version => fields[0],
      :name => fields[1],
      :port => fields[2],
      :owner => fields[4],
      :datadir => fields[5],
      :logfile => fields[6],
      :ensure => :present
    }
  end

  def create
    cmd=["/usr/bin/pg_createcluster"]
    if @resource[:owner] then
      cmd << "--user" << @resource[:owner]
    end
    
    if @resource[:datadir] then
      cmd << "--datadir" << @resource[:datadir]
    end
    
    if @resource[:socketdir] then
      cmd << "--socketdir" << @resource[:socketdir]
    end
    
    if @resource[:logfile] then
      cmd << "--logfile" << @resource[:logfile]
    end
    
    if @resource[:encoding] then
      cmd << "--encoding" << @resource[:encoding]
    end
    
    if @resource[:port] then
      cmd << "--port" << @resource[:port]
    end

    cmd << @resource[:version]
    cmd << @resource[:name]

    execute(cmd, {:failonfail => true, :combine => true})
  end

  def destroy
    cmd = ['/usr/bin/pg_dropcluster', '--stop']
    cmd << @resource[:version]
    cmd << @resource[:name]

    execute(cmd, {:uid => "postgres"})
  end

  def exists?
    cmd = ["/usr/bin/pg_lsclusters", "-h"]
    out = execute(cmd, {:uid => "postgres"})
    out.split("\n").each do |line|
      m = /^([^ \t]*)\s+([^ \t]*)\s+/.match(line)
      if m && (m[1] == @resource[:version]) && (m[2] == @resource[:name]) then
        return true
      end
    end
    return false
  end
end
