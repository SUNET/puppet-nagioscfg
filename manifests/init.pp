class nagioscfg(
  $hostgroups       = {},
  $cfgdir           = '/etc/nagios3/conf.d',
  $host_template    = 'generic-host',
  $config           = "nagioscfg",
  $manage_package   = true,
  $passive_monitor  = false)
{
  require stdlib
  if $manage_package {
    ensure_resource('package','nagios3', { ensure => present })
    ensure_resource('package','nagios-nrpe-plugin', { ensure => present })
    if $passive_monitor {
      ensure_resource('package', 'nsca-client', { ensure => present })
    }
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

  if $passive_monitor {
    require augeas
    nagioscfg::nagios_command { "obsessive_host_handler":
      command_line => '/usr/share/icinga/plugins/eventhandlers/distributed-monitoring/send_nsca_host_or_service_check_result \'$_HOSTOCHP_HOST$\' \'$_HOSTOCHP_CONFIG$\' \'$HOSTNAME$\' \'$HOSTSTATE$\' \'$HOSTOUTPUT$\\n$LONGHOSTOUTPUT$|$HOSTPERFDATA$\''
    } ->
    nagioscfg::nagios_command { "obsessive_service_handler":
      command_line => '/usr/share/icinga/plugins/eventhandlers/distributed-monitoring/send_nsca_host_or_service_check_result \'$_SERVICEOCSP_HOST$\' \'$_SERVICEOCSP_CONFIG$\' \'$HOSTNAME$\' \'$SERVICEDESC$\' \'$SERVICESTATE$\' \'$SERVICEOUTPUT$\\n$LONGSERVICEOUTPUT$|$SERVICEPERFDATA$\''
    } ->
    augeas { 'nagios_passive_monitor_settings':
      incl     => "/etc/nagios3/nagios.cfg",
      lens     => 'NagiosConfig.lns',
      changes  => [
        "set enable_notifications 0",
        "set obsess_over_services 1",
        "set obsess_over_hosts 1",
        "set ocsp_command obsessive_service_handler",
        "set ochp_command obsessive_host_handler"
      ]
    }
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
