class nagioscfg::passive {
  require augeas
  ensure_resource('package', 'nsca-client', { ensure => present })
  $nsca_server = hiera("nsca-server");
  $password = hiera("nsca-password");
  $encryption_method = hiera("nsca-encryption-method");

  nagioscfg::command { "obsessive_host_handler":
    command_line => "/usr/share/icinga/plugins/eventhandlers/distributed-monitoring/send_nsca_host_or_service_check_result '${nsca_server}' '/etc/send_nsca.cfg' '\$HOSTNAME\$' '\$HOSTSTATE\$' '\$HOSTOUTPUT\$\\n\$LONGHOSTOUTPUT\$|\$HOSTPERFDATA\$'"
  } ->
  nagioscfg::command { "obsessive_service_handler":
    command_line => "/usr/share/icinga/plugins/eventhandlers/distributed-monitoring/send_nsca_host_or_service_check_result '${nsca_server}' '/etc/send_nsca.cfg' '\$HOSTNAME\$' '\$SERVICEDESC\$' '\$SERVICESTATE\$' '\$SERVICEOUTPUT\$\\n\$LONGSERVICEOUTPUT\$|\$SERVICEPERFDATA\$'"
  } ->
  augeas { 'nagios_passive_monitor_settings':
    incl     => "/etc/nagios3/nagios.cfg",
    lens     => 'NagiosCfg.lns',
    changes  => [
      "set enable_notifications 0",
      "set obsess_over_services 1",
      "set obsess_over_hosts 1",
      "set ocsp_command obsessive_service_handler",
      "set ochp_command obsessive_host_handler"
    ]
  } ->
  file {'/etc/send_nsca.cfg':
     owner   => nagios,
     group   => nagios,
     mode    => '0400',
     content => template("nagioscfg/send_nsca.cfg.erb")
  }
}
