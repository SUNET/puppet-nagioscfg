
class { 'nagioscfg::checks': }
define nagioscfg::checks::zone ($hostgroup_name = []) {
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
