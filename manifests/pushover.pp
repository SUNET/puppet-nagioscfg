# Configure pushover
class nagioscfg::pushover {
  file { '/usr/lib/nagios/plugins/notify_by_pushover':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('nagioscfg/notify_by_pushover.erb')
  }

  $binary = '/usr/lib/nagios/plugins/notify_by_pushover'

  $command_line_one_h   = " -u '\$CONTACTADDRESS1\$' -a '\$CONTACTADDRESS2\$' -t '\$NOTIFICATIONTYPE\$ Host Alert: \$HOSTNAME\$"
  $command_line_two_h   = " is \$HOSTSTATE\$' -m 'Notification Type: \$NOTIFICATIONTYPE\$|Host: \$HOSTNAME\$|State: \$HOSTSTATE\$|Address:"
  $command_line_three_h = " \$HOSTADDRESS\$|Info: \$HOSTOUTPUT\$||Date/Time: \$LONGDATETIME\$'"

  nagioscfg::command { 'notify-host-by-pushover':
    command_line => "${binary}${command_line_one_h}${command_line_two_h}${command_line_three_h}"
  }

  $command_line_one_s  = " -u '\$CONTACTADDRESS1\$' -a '\$CONTACTADDRESS2\$' -t '\$NOTIFICATIONTYPE\$ Service Alert:"
  $command_line_two_s  = " \$HOSTALIAS\$/\$SERVICEDESC\$ is \$SERVICESTATE\$' -m 'Notification Type: \$NOTIFICATIONTYPE\$||Service:"
  $command_line_three_s = " \$SERVICEDESC\$|Host: \$HOSTALIAS\$|Address: \$HOSTADDRESS\$|State: \$SERVICESTATE\$||Date/Time:"
  $command_line_four_s = " \$LONGDATETIME\$||Additional Info:||\$SERVICEOUTPUT\$'"
  nagioscfg::command { 'notify-service-by-pushover':
    command_line => "${binary}${command_line_one_s}${command_line_two_s}${command_line_three_s}${command_line_four_s}"
  }
}
