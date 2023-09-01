# Configure pushover
class nagioscfg::pushover {
  file { '/usr/lib/nagios/plugins/notify_by_pushover':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('nagioscfg/notify_by_pushover.erb')
  }
  nagioscfg::command { 'notify-host-by-pushover':
  command_line => "/usr/lib/nagios/plugins/notify_by_pushover -u '\$CONTACTADDRESS1\$' -a '\$CONTACTADDRESS2\$' -t '\$NOTIFICATIONTYPE\$ Host Alert: \$HOSTNAME\$ is \$HOSTSTATE\$' -m 'Notification Type: \$NOTIFICATIONTYPE\$|Host: \$HOSTNAME\$|State: \$HOSTSTATE\$|Address: \$HOSTADDRESS\$|Info: \$HOSTOUTPUT\$||Date/Time: \$LONGDATETIME\$'" # lint:ignore:140chars
  }
  nagioscfg::command { 'notify-service-by-pushover':
    command_line => "/usr/lib/nagios/plugins/notify_by_pushover -u '\$CONTACTADDRESS1\$' -a '\$CONTACTADDRESS2\$' -t '\$NOTIFICATIONTYPE\$ Service Alert: \$HOSTALIAS\$/\$SERVICEDESC\$ is \$SERVICESTATE\$' -m 'Notification Type: \$NOTIFICATIONTYPE\$||Service: \$SERVICEDESC\$|Host: \$HOSTALIAS\$|Address: \$HOSTADDRESS\$|State: \$SERVICESTATE\$||Date/Time: \$LONGDATETIME\$||Additional Info:||\$SERVICEOUTPUT\$'" # lint:ignore:140chars
  }
}
