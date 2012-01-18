define postgresql::clusterhba(
  $version,
  $hbatype=[],
  $hbadatabase=[],
  $hbauser=[],
  $hbaaddress=[],
  $hbamethod=[],
  $hbaoptions=[] ) {
    
    file { "/etc/postgresql/${version}/${name}/pg_hba.conf":
      content => inline_template('<%= hbatype.zip(hbadatabase,hbauser,hbaaddress,hbamethod,hbaoptions).map{ |l| l.join(" ") }.join("\n") %>
')
    }
  }
  

define postgresql::hba (
  $cluster,
  $type,
  $database="all",
  $user="all",
  $address="",
  $method,
  $options="" ) {

    Postgresql::Clusterhba <| title==$cluster |> {
      hbatype +> $type,
      hbadatabase +> $database,
      hbauser +> $user,
      hbaaddress +> $address,
      hbamethod +> $method,
      hbaoptions +> $options
    }
}

