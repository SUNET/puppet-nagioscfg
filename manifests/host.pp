import stdlib
import concat

define nagioscfg::host() {
  $host_ip_list = dnsLookup($name)
  $host_ips = $host_ip_list ? {
    undef   => undef,
    []      => undef,
    default => join($host_ip_list, ',')
  }
  concat::fragment {"nagioscfg_host_${name}":
    target  => "${nagioscfg::cfgdir}/nagioscfg_hosts.cfg",
    content => template('nagioscfg/host.erb'),
    order   => 30,
    notify  => Service['nagios3']
  }
}
