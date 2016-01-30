class nagioscfg::pushover {
   file { '/usr/lib/nagios/plugins/notify_by_pushover':
     ensure  => file,
     owner   => root,
     group   => root,
     mode    => '0755',
     content => template('nagioscfg/notify_by_pushover.erb')
   }
   nagioscfg::command { 'notify-host-by-pushover': 
     command_line => "/usr/lib/nagios/plugins/notify_by_pushover -u '\$CONTACTADDRESS1\$' -a '\$CONTACTADDRESS2\$' -t '\$NOTIFICATIONTYPE\$ Host Alert: \$HOSTNAME\$ is \$HOSTSTATE\$' -m 'Notification Type: \$NOTIFICATIONTYPE\$\\nHost: \$HOSTNAME\$\\nState: \$HOSTSTATE\$\\nAddress: \$HOSTADDRESS\$\\nInfo: \$HOSTOUTPUT\$\\n\\nDate/Time: \$LONGDATETIME\$\\n'"
   }
}
