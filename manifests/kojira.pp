#
# == Class: koji::kojira
#
# Manages the Koji Kojira component on a host.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-koji Puppet module.
# Copyright 2016-2018 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


class koji::kojira (
        String[1]                                    $hub,
        String[1]                                    $top_dir,
        Boolean                                      $debug,
        Integer[0]                                   $deleted_repo_lifetime,
        Integer[0]                                   $dist_repo_lifetime,
        Variant[Boolean, Enum['running', 'stopped']] $ensure,
        Boolean                                      $enable,
        String[1]                                    $service,
    ) {

    include '::koji::utils'

    file { '/etc/kojira/kojira.conf':
        owner     => 'root',
        group     => 'root',
        mode      => '0644',
        seluser   => 'system_u',
        selrole   => 'object_r',
        seltype   => 'etc_t',
        content   => template('koji/kojira/kojira.conf.erb'),
        before    => Service[$service],
        notify    => Service[$service],
        subscribe => Class['::koji::utils'],
    }

    service { $service:
        ensure     => $ensure,
        enable     => $enable,
        hasrestart => true,
        hasstatus  => true,
        subscribe  => Class['::koji::utils'],
    }

}
