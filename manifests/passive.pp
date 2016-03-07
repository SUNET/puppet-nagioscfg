class nagioscfg::passive {
  require augeas
  ensure_resource('package', 'nsca-client', { ensure => present })
  nagioscfg::command { "obsessive_host_handler":
    command_line => '/usr/share/icinga/plugins/eventhandlers/distributed-monitoring/send_nsca_host_or_service_check_result \'$_HOSTOCHP_HOST$\' \'$_HOSTOCHP_CONFIG$\' \'$HOSTNAME$\' \'$HOSTSTATE$\' \'$HOSTOUTPUT$\\n$LONGHOSTOUTPUT$|$HOSTPERFDATA$\''
  } ->
  nagioscfg::command { "obsessive_service_handler":
    command_line => '/usr/share/icinga/plugins/eventhandlers/distributed-monitoring/send_nsca_host_or_service_check_result \'$_SERVICEOCSP_HOST$\' \'$_SERVICEOCSP_CONFIG$\' \'$HOSTNAME$\' \'$SERVICEDESC$\' \'$SERVICESTATE$\' \'$SERVICEOUTPUT$\\n$LONGSERVICEOUTPUT$|$SERVICEPERFDATA$\''
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
  }
  $password = hiera("nsca-password");
  $encryption_method = hiera("nsca-encryption-method");
  file {'/etc/send_nsca.conf':
     owner   => nagios,
     group   => nagios,
     mode    => '0400',
     content => template("nagioscfg/send_nsca.cnf.erb")
  }
}
