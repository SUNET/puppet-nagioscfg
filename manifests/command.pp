# Create command
define nagioscfg::command($command_line = undef) {
  require stdlib
  concat::fragment {"${nagioscfg::config}_command_${name}":
    target  => "${nagioscfg::cfgdir}/${nagioscfg::config}_commands.cfg",
    content => template('nagioscfg/command.erb'),
    order   => '30',
    notify  => Service[$nagioscfg::service]
  }
}
