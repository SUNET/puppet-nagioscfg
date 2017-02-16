include stdlib
include concat

define nagioscfg::hostgroup($hgalias = undef, $ensure = 'present', $members = undef) {
  $hostgroup_alias = $hgalias ? {
    undef   => $name,
    default => $hgalias
  }
  $def_members = has_key($nagioscfg::hostgroups, $name) ? {
    true  => $nagioscfg::hostgroups[$name],
    false => undef,
  }
  $hostgroup_members = $members ? {
    undef   => $def_members,
    default => join($members, ',')
  }
  concat::fragment {"${nagioscfg::config}_hostgroup_${name}":
    target  => "${nagioscfg::cfgdir}/${nagioscfg::config}_hostgroups.cfg",
    content => template('nagioscfg/hostgroup.erb'),
    order   => '30',
    notify  => Service['nagios3'],
    ensure  => $ensure
  }
}
