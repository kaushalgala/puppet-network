define network::pxe_cleanup (
  $ensure,
  $bootproto       = 'dhcp',
  $onboot          = "no"
) {
  $states = [ '^clean$', '^ignore$' ]
  validate_re($ensure, $states, '$ensure must be either "clean" or "ignore".')

  if is_mac_address($name) {
    $interface = map_macaddr_to_interface($name)
    if !$interface {
      fail('Could not find the interface name for the given macaddress...')
    }
    $macaddress = $name
  } else {
    fail('Resource name for network::pxe_cleanup must be the MAC address of the target port/partition!')
  }

  file { "ifcfg-${interface}":
    ensure  => 'present',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    path    => "/etc/sysconfig/network-scripts/ifcfg-${interface}",
    content => template("network/ifcfg-eth.erb"),
    notify => Service['network']
  }
} # define network::pxe_cleanup
