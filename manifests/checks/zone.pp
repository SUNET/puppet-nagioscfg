# Something with zones
define nagioscfg::checks::zone ($hostgroup_name = []) {

  ensure_resource('nagioscfg::command','check_zone_4', {
    command_line => "/usr/lib/nagios/plugins/check_dig -4 -H '\$HOSTNAME\$' -l '\$ARG1\$' -T '\$ARG2\$'"
  })
  ensure_resource('nagioscfg::command','check_zone_6', {
    command_line => "/usr/lib/nagios/plugins/check_dig -6 -H '\$HOSTNAME\$' -l '\$ARG1\$' -T '\$ARG2\$'"
  })
  nagioscfg::service {"${name}_SOA_4":
    check_command  => "check_zone_4!${name}!SOA",
    hostgroup_name => $hostgroup_name,
    description    => "${name} SOA v4"
  }
  nagioscfg::service {"${name}_SOA_6":
    check_command  => "check_zone_6!${name}!SOA",
    hostgroup_name => $hostgroup_name,
    description    => "${name} SOA v6"
  }
  nagioscfg::service {"${name}_NS_4":
    check_command  => "check_zone_4!${name}!NS",
    hostgroup_name => $hostgroup_name,
    description    => "${name} NS v4"
  }
  nagioscfg::service {"${name}_NS_6":
    check_command  => "check_zone_6!${name}!NS",
    hostgroup_name => $hostgroup_name,
    description    => "${name} NS v6"
  }
}
