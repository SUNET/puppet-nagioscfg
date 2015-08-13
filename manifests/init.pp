class nagioscfg($hostgroups={}, $cfgdir='/etc/nagios3', $host_template='host', $config = "nagioscfg") {
  package {'nagios3': ensure => present }
  service {'nagios3': ensure => running }
  if has_key($hostgroups,'all') {
    each($hostgroups['all']) |$hostname| {
      notify {"generating ${hostname}": }
      nagioscfg::host {$hostname: }
    }
  }
  each($hostgroups) |$hgn, $members| {
     nagioscfg::hostgroup {$hgn: members => $members}
  }
}
