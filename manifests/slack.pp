class nagioscfg::slack($domain=undef,$token=undef) {
   file {"/usr/lib/nagios/plugins/slack_nagios.pl": 
     ensure  => file,
     owner   => root,
     group   => root,
     mode    => '0755',
     content => template('nagioscfg/slack_nagios.erb')
   }
}

define nagioscfg::slack::channel() {
   nagioscfg::command {"notify-host-to-slack-$name":
      command_line => "/usr/lib/nagios/plugins/slack_nagios.pl -field slack_channel=#$name -field HOSTALIAS='\$HOSTNAME\$' -field SERVICEDESC='\$SERVICEDESC\$' -field SERVICESTATE='\SERVICESTATE\$' -field SERVICEOUTPUT='\$SERVICEOUTPUT\$' -field NOTIFICATIONTYPE='\$NOTIFICATIONTYPE\$'"
   }
   nagioscfg::command {"notify-service-to-slack-$name":
      command_line => "/usr/lib/nagios/plugins/slack_nagios.pl -field slack_channel=#$name -field HOSTALIAS='\$HOSTNAME\$' -field HOSTSTATE='\$HOSTSTATE\$' -field HOSTOUTPUT='\$HOSTOUTPUT\$' -field NOTIFICATIONTYPE='\$NOTIFICATIONTYPE\$'"
   }
}
