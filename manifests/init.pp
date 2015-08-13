class nagioscfg($hostgroups={}, $cfgdir='/etc/nagios3', $host_template='host') {
  if has_key($hostgroups,'all') {
    $hostgroups['all'].each |$hostname| {
      nagioscfg::host {$hostname: }
    }
  }
}
