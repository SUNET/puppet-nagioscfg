# Nagios configuration class
class nagioscfg(
  $cfgdir              = '/etc/nagios3/conf.d',
  $config              = 'nagioscfg',
  $contactgroups       = {},
  $exclude_hosts       = [],
  $host_template       = 'generic-host',
  $hostgroups          = $facts['configured_hosts_in_cosmos'],
  $manage_package      = true,
  $manage_service      = true,
  $service             = 'nagios3',
  $single_ip           = false,
  $sort_alphabetically = false,
  Optional[String] $default_host_group = undef,
  Optional[Hash] $custom_host_fields = undef,
  Hash $additional_entities = {},
)
{
  if $manage_package {
    ensure_resource('package','nagios3', { ensure => present })
    ensure_resource('package','nagios-nrpe-plugin', { ensure => present })
  }
  if $manage_service {
    ensure_resource('service',$service, { ensure => running })
  }

  exec { 'systemd-naemon':
    command     => 'systemctl reload sunet-naemon_monitor',
    onlyif      => 'test -f /etc/system/systemd/sunet-naemon_monitor.service',
    refreshonly => true
  }

  if ($service == 'sunet-naemon_monitor'){
    $target_to_notify =  Exec['systemd-naemon']
  } else {
    $target_to_notify =  Service[$service]
  }

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
    content => '# Do not edit by hand - maintained by puppet',
    order   => '10',
    notify  => $target_to_notify
  }
  concat {"${cfgdir}/${config}_hosts.cfg":
    owner => root,
    group => root,
    mode  => '0644'
  }
  concat::fragment {"${config}_hosts_header":
    target  => "${cfgdir}/${config}_hosts.cfg",
    content => '# Do not edit by hand - maintained by puppet',
    order   => '10',
    notify  => $target_to_notify
  }
  concat {"${cfgdir}/${config}_servicegroups.cfg":
    owner => root,
    group => root,
    mode  => '0644'
  }
  concat::fragment {"${config}_servicegroups_header":
    target  => "${cfgdir}/${config}_servicegroups.cfg",
    content => '# Do not edit by hand - maintained by puppet',
    order   => '10',
    notify  => $target_to_notify
  }
  concat {"${cfgdir}/${config}_services.cfg":
    owner => root,
    group => root,
    mode  => '0644'
  }
  concat::fragment {"${config}_services_header":
    target  => "${cfgdir}/${config}_services.cfg",
    content => '# Do not edit by hand - maintained by puppet',
    order   => '10',
    notify  => $target_to_notify
  }
  concat {"${cfgdir}/${config}_contactgroups.cfg":
    owner => root,
    group => root,
    mode  => '0644'
  }
  concat::fragment {"${config}_contactgroups_header":
    target  => "${cfgdir}/${config}_contactgroups.cfg",
    content => '# Do not edit by hand - maintained by puppet',
    order   => '10',
    notify  => $target_to_notify
  }
  concat {"${cfgdir}/${config}_commands.cfg":
    owner => root,
    group => root,
    mode  => '0644'
  }
  concat::fragment {"${config}_commands_header":
    target  => "${cfgdir}/${config}_commands.cfg",
    content => '# Do not edit by hand - maintained by puppet',
    order   => '10',
    notify  => $target_to_notify
  }
  concat {"${cfgdir}/${config}_contacts.cfg":
    owner => root,
    group => root,
    mode  => '0644'
  }
  concat::fragment {"${config}_contacts_header":
    target  => "${cfgdir}/${config}_contacts.cfg",
    content => '# Do not edit by hand - maintained by puppet',
    order   => '10',
    notify  => $target_to_notify
  }

  if has_key($hostgroups,'all') {
    each($hostgroups['all']) |$hostname| {
      unless $hostname in $exclude_hosts {
        notify {"generating ${hostname}": }
        if $custom_host_fields == undef {
          nagioscfg::host { $hostname:
            default_host_group  => $default_host_group,
            single_ip           => $single_ip,
            sort_alphabetically => $sort_alphabetically,
          }
        } elsif $custom_host_fields != undef {
          nagioscfg::host {$hostname:
            custom_host_fields  => $custom_host_fields[$hostname],
            default_host_group  => $default_host_group,
            single_ip           => $single_ip,
            sort_alphabetically => $sort_alphabetically,
            }
        }
      }
    }
  }

  each($hostgroups) |$hgn, $members| {
    if $hgn != 'all' {
      $filtered_members = delete($members, $exclude_hosts)
      nagioscfg::hostgroup {$hgn: members => $filtered_members}
    }
  }

  # Run over all additional entities and create them but don't add any
  # default_host_group since the default group is uses add nrpe checks by
  # sunet::naemon_monitor and it's not sure if all additional hosts can talk
  # NRPE with us.
  each($additional_entities) |$hgn, $members| {
    each($members) |$hostname| {
      notify {"generating ${hostname}": }
      nagioscfg::host {$hostname: single_ip => $single_ip, sort_alphabetically => $sort_alphabetically}
    }
    nagioscfg::hostgroup {$hgn: members => $members}
  }

}
