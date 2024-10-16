# Create contacts groups
define nagioscfg::contactgroup($cgalias = undef, $ensure = 'present', $members = undef) {
  $contactgroup_alias = $cgalias ? {
    undef   => $name,
    default => $cgalias
  }
  $def_members = $name in $nagioscfg::contactgroups ? {
    true  => $nagioscfg::contactgroups[$name],
    false => undef,
  }
  $contactgroup_members = $members ? {
    undef   => $def_members,
    default => join($members, ',')
  }
  concat::fragment {"${nagioscfg::config}_contactgroup_${name}":
    target  => "${nagioscfg::cfgdir}/${nagioscfg::config}_contactgroups.cfg",
    content => template('nagioscfg/contactgroup.erb'),
    order   => '30',
  }
}
