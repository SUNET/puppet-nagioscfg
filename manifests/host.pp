include stdlib
include concat
# Use a template to create a host config
define nagioscfg::host($ensure='present',
  $single_ip=false,
  $action_url = undef,
  Optional[String] $default_host_group = undef,
) {
  $temp_ip_list = sort(dnsLookup($name))
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
    ensure  => $ensure,
    target  => "${nagioscfg::cfgdir}/${nagioscfg::config}_hosts.cfg",
    content => template('nagioscfg/host.erb'),
    order   => '30',
    notify  => Service[$nagioscfg::service],
  }
}
