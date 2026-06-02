class nagioscfg::slack($domain=undef,$token=undef) {
  file {'/usr/lib/nagios/plugins/slack_nagios.pl':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('nagioscfg/slack_nagios.erb')
  }
}
