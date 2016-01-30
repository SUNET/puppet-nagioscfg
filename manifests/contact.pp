include stdlib
include concat

define nagioscfg::contact($ensure = 'present',
                          $contact_groups = ['admins'],
                          $host_notifications_enabled = '1',
                          $service_notifications_enabled = '1',
                          $host_notification_period = "24x7",
                          $service_notification_period = "24x7",
                          $host_notification_options = 'd,u,r',
                          $service_notification_options = 'w,u,c,r',
                          $service_notification_commands = ['notify-by-email'],
                          $host_notification_commands = ['host-notify-by-email'],
                          $email = undef,
                          $pushover_user = undef,
                          $pushover_key = undef,
                          $can_submit_commands = '1'
) {
  $contact_groups_list = any2array($contact_groups)
  $contact_groups_joined = join($contact_groups_list,',')
  $service_notification_commands_list = any2array($service_notification_commands)
  $service_notification_commands_joined = join($service_notification_commands_list,',')
  $host_notification_commands_list = any2array($host_notification_commands)
  $host_notification_commands_joined = join($host_notification_commands_list,',')
  concat::fragment {"${nagioscfg::config}_contact_${name}":
    target  => "${nagioscfg::cfgdir}/${nagioscfg::config}_contacts.cfg",
    content => template('nagioscfg/contact.erb'),
    order   => '30',
    notify  => Service['nagios3']
  }
}
