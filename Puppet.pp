package { 'vim':
  ensure => installed,
}

package { 'curl':
  ensure => installed,
}

package { 'git':
  ensure => installed,
}

file { '/home/monitor/':
  ensure => directory,
}

user { 'monitor':
  home => '/home/monitor',
  ensure => present,
  shell => '/bin/bash',
}

file { '/home/monitor/scripts':
  ensure => directory,
}

exec { 'download_script':
  command => '/usr/bin/wget -q https://raw.githubusercontent.com/miguelawili/se-exercise1/master/memory_check.sh -O /home/monitor/scripts/memory_check.sh',
  creates => "/home/monitor/scripts/memory_check.sh",
}

file { '/home/monitor/scripts/memory_check.sh':
  mode => '0755',
  require => Exec["download_script"],
}

file { '/home/monitor/src':
  ensure => directory,
}

file { '/home/monitor/src/my_memory_check.sh':
  ensure => 'link',
  target => '/home/monitor/scripts/memory_check.sh',
}

cron { 'my_memory_check':
  command => '/home/monitor/scripts/memory_check.sh -c 90 -w 60 -e miguelawili@gmail.com',
  user => 'root',
  hour => '*',
  minute  => '*/10',
}

exec { 'hostname':
  command => 'hostname bpx.server.local',
  path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
}

exec { 'timezone_bak':
  command => 'mv /etc/localtime /etc/localtime.bak',
  path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
}

exec { 'timezone':
  command => 'ln -s /usr/share/zoneinfo/Asia/Manila /etc/localtime',
  path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
}
