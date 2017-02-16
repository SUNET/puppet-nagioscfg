include stdlib
include concat

define nagioscfg::host($ensure='present') {
  $host_ip_list = dnsLookup($name)
  $host_ips = $host_ip_list ? {
    undef   => undef,
    []      => undef,
    default => join($host_ip_list, ',')
  }
  concat::fragment {"${nagioscfg::config}_host_${name}":
    target  => "${nagioscfg::cfgdir}/${nagioscfg::config}_hosts.cfg",
    content => template('nagioscfg/host.erb'),
    order   => '30',
    notify  => Service['nagios3'],
    ensure  => $ensure
  }
}
