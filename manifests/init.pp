class nagioscfg($hostgroups={}, $cfgdir='/etc/nagios3', $host_template='host', $config = "nagioscfg") {
  if has_key($hostgroups,'all') {
    each($hostgroups['all']) |$hostname| {
      nagioscfg::host {$hostname: }
    }
  }
}
