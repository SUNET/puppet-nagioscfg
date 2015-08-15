define nagioscfg::checks::zone ($hostgroup_name = []) {
  nagioscfg::command {"check_zone_${name}_4":
    command_line => "/usr/lib/nagios/plugins/check_dig -4 -H '\$HOSTNAME$' -l ${name} -T '\$ARG1\$' -w 4000 -c 6000"
  }
  nagioscfg::command {"check_zone_${name}_6":
    command_line => "/usr/lib/nagios/plugins/check_dig -6 -H '\$HOSTNAME$' -l ${name} -T '\$ARG1\$' -w 4000 -c 6000"
  }
  nagioscfg::service {"${name}_SOA_4":
    check_command  => "check_zone_${name}_4!${name}!SOA",
    hostgroup_name => $hostgroup_name,
    description    => "${name} SOA v4"
  }
  nagioscfg::service {"${name}_SOA_6":
    check_command  => "check_zone_${name}_6!${name}!SOA",
    hostgroup_name => $hostgroup_name,
    description    => "${name} SOA v6"
  }
  nagioscfg::service {"${name}_NS_4":
    check_command  => "check_zone_${name}_4!${name}!NS",
    hostgroup_name => $hostgroup_name,
    description    => "${name} NS v4"
  }
  nagioscfg::service {"${name}_NS_6":
    check_command  => "check_zone_${name}_6!${name}!NS",
    hostgroup_name => $hostgroup_name,
    description    => "${name} NS v6"
  }
}
