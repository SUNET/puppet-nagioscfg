
class nagioscfg::checks {
  nagioscfg::command {"check_zone_4":
    command_line => "/usr/lib/nagios/plugins/check_dig -4 -H '\$HOSTNAME\$' -l '\$ARG1\$' -T '\$ARG2\$'"
  }
  nagioscfg::command {"check_zone_6":
    command_line => "/usr/lib/nagios/plugins/check_dig -6 -H '\$HOSTNAME\$' -l '\$ARG1\$' -T '\$ARG2\$'"
  }
}
