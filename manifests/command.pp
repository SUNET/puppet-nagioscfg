include stdlib
include concat

define nagioscfg::command($command_line = undef) {
  concat::fragment {"${nagioscfg::config}_command_${name}":
    target  => "${nagioscfg::cfgdir}/${nagioscfg::config}_commands.cfg",
    content => template('nagioscfg/command.erb'),
    order   => '30',
    notify  => Service['nagios3']
  }
}

