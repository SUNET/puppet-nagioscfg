import stdlib

define nagioscfg::checks::uri_content($match = undef) {
  ensure_resource('nagioscfg::command', 'check_http_content', {
      command_line   => '/usr/lib/nagios/plugins/check_http -H \'$HOSTNAME\$\' -e \'$ARG1$\''
  })
  $f = fqdn_rand(1000, $name)
  nagioscfg::service {"check_${name}_${f}":
    host_name      => [$name],
    check_command  => "check_http_content!${match}",
    description    => "http://${name}/ contains '${match}'"
  }
}
