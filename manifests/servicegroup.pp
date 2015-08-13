include stdlib
include concat

define nagioscfg::servicegroup($alias = undef, $ensure = 'present', $members = undef) {
  $servicegroup_alias = $alias ? {
    undef   => $name,
    default => $alias
  }
  $servicegroup_members = $members ? {
    undef   => undef,
    default => join($members, ',')
  }
  concat::fragment {"nagioscfg_servicegroup_${name}":
    target  => "${nagioscfg::cfgdir}/nagioscfg_servicegroups.cfg",
    content => template('nagioscfg/servicegroup.erb'),
    order   => 30,
    notify  => Service['nagios3']
  }
}
