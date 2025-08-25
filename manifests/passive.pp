# The passives
class nagioscfg::passive (
  String $enable_notifications = '0',
  String $obsess_over_services = '1',
  String $obsess_over_hosts    = '1',
  String $nsca_server          = hiera('nsca_server'),
  String $password             = hiera('nsca_password'),
  String $encryption_method    = hiera('nsca_encryption_method', '14'),  # 14 is AES-128
  String $nagios_config_file   = '/etc/nagios3/nagios.cfg',
) {
  ensure_resource('package', 'nsca-client', { ensure => present })

  $binary = '/usr/share/icinga/plugins/eventhandlers/distributed-monitoring/send_nsca_host_or_service_check_result'
  $command_line_one_h = " '${nsca_server}' '/etc/send_nsca.cfg' '\$HOSTNAME\$' '\$HOSTSTATE\$'"
  $command_line_two_h = " '\$HOSTOUTPUT\$\\n\$LONGHOSTOUTPUT\$|\$HOSTPERFDATA\$'"

  $command_line_one_s = " '${nsca_server}' '/etc/send_nsca.cfg' '\$HOSTNAME\$' '\$SERVICEDESC\$' '\$SERVICESTATE\$'"
  $command_line_two_s = " '\$SERVICEOUTPUT\$\\n\$LONGSERVICEOUTPUT\$|\$SERVICEPERFDATA\$'"

  nagioscfg::command { 'obsessive_host_handler':
    command_line => "${binary}${command_line_one_h}${command_line_two_h}"
  }
  -> nagioscfg::command { 'obsessive_service_handler':
    command_line => "${binary}${command_line_one_s}${command_line_two_s}"
  }
  -> augeas { 'nagios_passive_monitor_settings':
    incl    => $nagios_config_file,
    lens    => 'NagiosCfg.lns',
    changes => [
      "set enable_notifications ${enable_notifications}",
      "set obsess_over_services ${obsess_over_services}",
      "set obsess_over_hosts ${obsess_over_hosts}",
      'set ocsp_command obsessive_service_handler',
      'set ochp_command obsessive_host_handler'
    ]
  }
  -> file {'/etc/send_nsca.cfg':
    owner   => nagios,
    group   => nagios,
    mode    => '0400',
    content => template('nagioscfg/send_nsca.cfg.erb')
  }
}
