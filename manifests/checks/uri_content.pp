include stdlib

# Something with URIs
define nagioscfg::checks::uri_content($match = undef, $uri = '/') {
  ensure_resource('nagioscfg::command', 'check_http_content', {
      command_line   => "/usr/lib/nagios/plugins/check_http -H '\$HOSTNAME\$' -u '\$ARG2\$' -s '\$ARG1\$'"
  })
  $f = fqdn_rand(1000, "${name}_${uri}")
  nagioscfg::service {"check_${name}_${uri}_${f}":
    host_name     => [$name],
    check_command => "check_http_content!${match}!${uri}",
    description   => "http://${name}${uri} contains ${match}"
  }
}
