include stdlib

class nagioscfg($hostgroups={}, $cfgdir='/etc/nagios3/conf.d', $host_template='generic-host', $config = "nagioscfg", $manage_package = true) {
  if $manage_package { 
    ensure_resource('package','nagios3', { ensure => present })
    ensure_resource('package','nagios-nrpe-plugin', { ensure => present })
  }
  ensure_resource('service','nagios3', { ensure => running })
  file { '/etc/nagios-plugins/config/check_ssh_4_hostname.cfg':
     ensure  => file,
     content => template('nagioscfg/check_ssh_4_hostname.cfg.erb')
  }
  concat {"${cfgdir}/${config}_hostgroups.cfg":
    owner => root,
    group => root,
    mode  => '0644'
  }
  concat::fragment {"${config}_hostgroups_header":
    target  => "${cfgdir}/${config}_hostgroups.cfg",
    content => "# Do not edit by hand - maintained by puppet",
    order   => '10',
    notify  => Service['nagios3']
  }
  concat {"${cfgdir}/${config}_hosts.cfg":
    owner => root,
    group => root,
    mode  => '0644'
  }
  concat::fragment {"${config}_hosts_header":
    target  => "${cfgdir}/${config}_hosts.cfg",
    content => "# Do not edit by hand - maintained by puppet",
    order   => '10',
    notify  => Service['nagios3']
  }
  concat {"${cfgdir}/${config}_servicegroups.cfg":
    owner => root,
    group => root,
    mode  => '0644'
  }
  concat::fragment {"${config}_servicegroups_header":
    target  => "${cfgdir}/${config}_servicegroups.cfg",
    content => "# Do not edit by hand - maintained by puppet",
    order   => '10',
    notify  => Service['nagios3']
  }
  concat {"${cfgdir}/${config}_services.cfg":
    owner => root,
    group => root,
    mode  => '0644'
  }
  concat::fragment {"${config}_services_header":
    target  => "${cfgdir}/${config}_services.cfg",
    content => "# Do not edit by hand - maintained by puppet",
    order   => '10',
    notify  => Service['nagios3']
  }
  concat {"${cfgdir}/${config}_commands.cfg":
    owner => root,
    group => root,
    mode  => '0644'
  }
  concat::fragment {"${config}_commands_header":
    target  => "${cfgdir}/${config}_commands.cfg",
    content => "# Do not edit by hand - maintained by puppet",
    order   => '10',
    notify  => Service['nagios3']
  }
  concat {"${cfgdir}/${config}_contacts.cfg":
    owner => root,
    group => root,
    mode  => '0644'
  }
  concat::fragment {"${config}_contacts_header":
    target  => "${cfgdir}/${config}_contacts.cfg",
    content => "# Do not edit by hand - maintained by puppet",
    order   => '10',
    notify  => Service['nagios3']
  }
  if has_key($hostgroups,'all') {
    each($hostgroups['all']) |$hostname| {
      notify {"generating ${hostname}": }
      nagioscfg::host {$hostname: }
    }
  }
  each($hostgroups) |$hgn, $members| {
     if $hgn != 'all' {
        nagioscfg::hostgroup {$hgn: members => $members}
     }
  }
}
