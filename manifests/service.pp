import stdlib
import concat

define nagioscfg::service($ensure = 'present',
                          $hostgroup_name = undef,
                          $host_name = undef,
                          $description = undef,
                          $check_command = undef,
                          $use = undef,
                          $contact_groups = undef,
                          $notes = undef) {
  $hostgroup_list = $hostgroup_name ? {
    undef   => undef,
    default => join($hostgroup_name, ',')
  }
  $host_list = $host_name ? {
    undef   => undef,
    default => join($host_name, ',')
  }
  $check_command_str = $check_command ? {
    undef   => $name,
    default => $check_command
  }
  $contact_groups_list = $contact_groups ? {
    undef   => $name,
    default => join($contact_groups, ',')
  }
  concat::fragment {"${nagioscfg::config}_service_${name}":
    target  => "${nagioscfg::cfgdir}/${nagioscfg::config}_services.cfg",
    content => template('nagioscfg/service.erb'),
    order   => 30,
    notify  => Service['nagios3']
  }
}
