class nagioscfg(
  $hostgroups       = {},
  $contactgroups    = {},
  $cfgdir           = '/etc/nagios3/conf.d',
  $host_template    = 'generic-host',
  $config           = "nagioscfg",
  $manage_package   = true,
  $service	    = "nagios3")
{
  require stdlib
  if $manage_package {
    ensure_resource('package','nagios3', { ensure => present })
    ensure_resource('package','nagios-nrpe-plugin', { ensure => present })
  }
  ensure_resource('service',$service, { ensure => running })

  file { '/etc/nagios-plugins/config/check_ssh_4_hostname.cfg':
     ensure  => file,
     content => template('nagioscfg/check_ssh_4_hostname.cfg.erb')
  }
  file { '/usr/bin/nagios-export.py': 
     ensure  => file,
     content => template('nagioscfg/nagios-export.erb'),
     owner   => 'root',
     group   => 'root',
     mode    => '0755'
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
    notify  => Service[$service]
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
    notify  => Service[$service]
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
    notify  => Service[$service]
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
    notify  => Service[$service]
  }
  concat {"${cfgdir}/${config}_contactgroups.cfg":
    owner => root,
    group => root,
    mode  => '0644'
  }
  concat::fragment {"${config}_contactgroups_header":
    target  => "${cfgdir}/${config}_contactgroups.cfg",
    content => "# Do not edit by hand - maintained by puppet",
    order   => '10',
    notify  => Service[$service]
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
    notify  => Service[$service]
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
    notify  => Service[$service]
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
