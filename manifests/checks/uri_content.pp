define nagioscfg::checks::uri_content($match = undef) {
  ensure_resource('nagioscfg::command', 'check_http_content', {
      command_line   => '/usr/lib/nagios/plugins/check_http -H \'$HOSTNAME\$\' -e \'$ARG1$\''
  })
  nagioscfg::service {'check_${name}_uri_content':
    host_name      => [$name],
    check_command  => "check_http_content!${match}",
    description    => "http://${name}/ ('${match}')"
  }
}
