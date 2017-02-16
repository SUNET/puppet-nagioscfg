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
      command-line => "/usr/lib/nagios/plugins/slack_nagios.pl -field slack_channel=#$name"
   }
   nagioscfg::command {"notify-service-to-slack-$name":
      command-line => "/usr/lib/nagios/plugins/slack_nagios.pl -field slack_channel=#$name"
   }
}
