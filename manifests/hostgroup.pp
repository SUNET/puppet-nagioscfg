include stdlib
include concat

define nagioscfg::hostgroup($alias = undef, $ensure = 'present', $members = undef) {
  $hostgroup_alias = $alias ? {
    undef   => $name,
    default => $alias
  }
  $def_members = has_key($nagioscfg::hostgroups, $name) ? {
    true  => $nagioscfg::hostgroups[$name],
    false => undef,
  }
  $hostgroup_members = $members ? {
    undef   => $def_members,
    default => join($members, ',')
  }
  concat::fragment {"nagioscfg_hostgroup_${name}":
    target  => "${nagioscfg::cfgdir}/nagioscfg_hostgroups.cfg",
    content => template('nagioscfg/hostgroup.erb'),
    order   => 30,
    notify  => Service['nagios3']
  }
}
