include stdlib
include concat
# Use a template to create a host config
define nagioscfg::host($ensure='present',
  $single_ip=false,
  $action_url = undef,
) {
  $temp_ip_list = dnsLookup($name)
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

  concat::fragment {"${nagioscfg::config}_host_${name}":
    ensure  => $ensure,
    target  => "${nagioscfg::cfgdir}/${nagioscfg::config}_hosts.cfg",
    content => template('nagioscfg/host.erb'),
    order   => '30',
    notify  => Service[$nagioscfg::service],
  }
}
