define check_uri_content($match = undef) {
  nagioscfg::service {'check_${name}_uri_content':
    host_name      => [$name],
    check_command  => "check_http_content!${match}",
    description    => "http://${name}/ ('${match}')"
  }
}
