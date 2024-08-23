# Create command
define nagioscfg::command($command_line = undef) {
  concat::fragment {"${nagioscfg::config}_command_${name}":
    target  => "${nagioscfg::cfgdir}/${nagioscfg::config}_commands.cfg",
    content => template('nagioscfg/command.erb'),
    order   => '30',
  }
}
