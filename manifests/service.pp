include stdlib
include concat

define nagioscfg::service($ensure = 'present',
                          $action_url = undef,
                          $hostgroup_name = undef,
                          $host_name = undef,
                          $description = undef,
                          $check_command = undef,
                          $use = undef,
                          $contact_groups = ['admins'],
                          $notes = undef,
                          $register = "1",
                          $check_period = "24x7",
                          $notification_period = "24x7",
                          $max_check_attempts = "4",
                          $check_interval = "5",
                          $retry_interval = "1"
) {
  $hostgroup_list = $hostgroup_name ? {
    undef   => undef,
    default => join($hostgroup_name, ',')
  }
  $host_list = $host_name ? {
    undef   => undef,
    default => join($host_name, ',')
  }
  $contact_groups_list = $contact_groups ? {
    undef   => undef,
    default => join($contact_groups, ',')
  }
  concat::fragment {"${nagioscfg::config}_service_${name}":
    target  => "${nagioscfg::cfgdir}/${nagioscfg::config}_services.cfg",
    content => template('nagioscfg/service.erb'),
    order   => '30',
    notify  => Service["${nagioscfg::service}"],
    ensure  => $ensure
  }
}
