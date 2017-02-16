include stdlib
include concat

define nagioscfg::servicegroup($sgalias = undef, $ensure = 'present', $members = undef) {
  $servicegroup_alias = $sgalias ? {
    undef   => $name,
    default => $sgalias
  }
  $servicegroup_members = $members ? {
    undef   => undef,
    default => join($members, ',')
  }
  concat::fragment {"${nagioscfg::config}_servicegroup_${name}":
    target  => "${nagioscfg::cfgdir}/${nagioscfg::config}_servicegroups.cfg",
    content => template('nagioscfg/servicegroup.erb'),
    order   => '30',
    notify  => Service['nagios3'],
    ensure  => $ensure
  }
}
