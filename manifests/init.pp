# Class: cobbler
#
# This module manages cobbler
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class cobbler {
    package { "PyYAML":
        ensure => "installed"
    }

    package { "cobbler-web":
        ensure => "installed",
        require    => Package["PyYAML"];
    }

    package { "dhcp":
        ensure => "installed";
    }

    service { "cobblerd":
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package["cobbler-web"];
    }
    
    file { "/etc/xinetd.d/rsync":
        ensure  => "present",
        require => Package["cobbler-web"],
        source  => "puppet:///cobbler/xinetd.d/rsync";
    }

    file { "/etc/xinetd.d/tftp":
        ensure  => "present",
        require => Package["cobbler-web"],
        source  => "puppet:///cobbler/xinetd.d/tftp";
    }

    file { "/etc/cobbler/modules.conf":
        ensure  => "present",
        require => Package["cobbler-web"],
        source  => "puppet:///cobbler/modules.conf";
    }

    file { "/etc/cobbler/users.digest":
        ensure  => "present",
        require => Package["cobbler-web"],
        source  => "puppet:///cobbler/users.digest";
    }

    file { "/etc/cobbler/settings":
        ensure  => "present",
        require => Package["cobbler-web"],
        source  => "puppet:///cobbler/settings";
    }

    file { "/etc/cobbler/dhcp.template":
        ensure  => "present",
        require => Package["cobbler-web"],
        source  => "puppet:///cobbler/dhcp.template";
    }

    file { "/var/lib/cobbler/loaders/":
               source => "puppet:///cobbler/loaders/",
               sourceselect => all,
               mode    => 0644,
               owner   => "root",
               group   => "root",
               recurse => true,
               purge => false,
               replace => true,
               require => Package["cobbler-web"],
    }

    ## you can provide here to kickstart files
    #file { "/var/lib/cobbler/kickstarts/name.ks":
    #           source => "puppet:///cobbler/ks/name.ks",
    #           mode    => 0666,
    #           owner   => "root",
    #           group   => "root",
    #           replace => true,
    #           require => Package["cobbler-web"],
    #}
}
