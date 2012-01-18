
class postgresql::base {
  if !$postgresql_ensure_version {
    $postgresql_ensure_version = 'installed'
  }

  if !$postgresql_version {
    case $lsbdistcodename {
      squeeze: {
        $postgresql_version = '8.4'
      }
      default: {
        $postgresql_version = '9,1'
      }
    }
  }
}
