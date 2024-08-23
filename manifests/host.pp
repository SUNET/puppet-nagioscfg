# Use a template to create a host config
define nagioscfg::host(
  $single_ip                           = false,
  $action_url                          = undef,
  $sort_alphabetically                 = false,
  Optional[String] $default_host_group = undef,
  Optional[Hash] $custom_host_fields = undef,
) {
  $unsorted_temp_ip_list = dnsLookup($name)
  if $sort_alphabetically {
    $temp_ip_list = sort($unsorted_temp_ip_list)
  } else {
    $temp_ip_list = $unsorted_temp_ip_list
  }
  if $single_ip {
    $host_ip_list = [ $temp_ip_list[0] ]
  } else {
    $host_ip_list = $temp_ip_list
  }

  $host_ips = $host_ip_list ? {
    undef   => undef,
    []      => undef,
    default => join($host_ip_list, ',')
  }

  # BYOF (Bring Your Own Fact) for the parents. For insperation see swamid-ops
  # and the facters for the monitor hosts.
  if $facts["parents_to_${name}"]{
    $parents = $facts["parents_to_${name}"]
  }

  concat::fragment {"${nagioscfg::config}_host_${name}":
    target  => "${nagioscfg::cfgdir}/${nagioscfg::config}_hosts.cfg",
    content => template('nagioscfg/host.erb'),
    order   => '30',
  }
}
