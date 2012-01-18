class postgresql::server inherits postgresql::base {
  package { postgresql:
    name => "postgresql-${postgresql_version}",
    ensure => $postgresql_ensure_version,
  }

  package { postgresql-contrib:
    name => "postgresql-contrib-${postgresql_version}",
    ensure => $postgresql_ensure_version,
  }

  service { postgresql:
    ensure => running,
    enable => true,
    hasstatus => true,
    require => Package['postgresql']
  }
}
