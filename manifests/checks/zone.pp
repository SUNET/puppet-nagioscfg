define nagioscfg::checks::zone ($hostgroup_name = []) {
  nagioscfg::command {"check_zone_${name}":
    command_line => "/usr/lib/nagios/plugins/check_dig -H '$HOSTADDRESS$' -l ${name} -T '$ARG1$'"
  }
  nagioscfg::service {"${name}_SOA":
    check_command  => "check_zone_${name}!${name}!SOA",
    hostgroup_name => $hostgroup_name,
    description    => "${name} SOA"
  }
  nagioscfg::service {"${name}_NS":
    check_command  => "check_zone_${name}!${name}!NS",
    hostgroup_name => $hostgroup_name,
    description    => "${name} NS"
  }
}
