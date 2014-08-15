class maven {

  require wget
  $version = '3.2.2'

  file { "/tmp/apache-maven-${version}-bin.tar.gz":
    ensure => present,
    require => Exec['Fetch maven'],
  }
  
  file { "/op/boxen/apache-maven":
    ensure => "directory",
    require => Exec['Fetch Maven'],
  }

  exec { 'Fetch maven':
    cwd => '/tmp',
    command => "wget http://apache.komsys.org/maven/maven-3/${version}/binaries/apache-maven-${version}-bin.tar.gz",
    creates => "/tmp/apache-maven-${version}-bin.tar.gz",
    path    => ['/opt/boxen/homebrew/bin'];
  }

  exec { 'Extract maven':
    cwd     => '/opt/boxen/apache-maven',
    command => "tar xvf /tmp/apache-maven-${version}-bin.tar.gz",
    creates => "/opt/boxen/apache-maven/apache-maven-${version}",
    path    => ['/usr/bin'],
    require => Exec['Fetch maven'];
  }

  file { "/opt/boxen/apache-maven/apache-maven-${version}":
    require => Exec['Extract maven'];
  }

  file { '/opt/boxen/apache-maven/maven':
    ensure  => link,
    target  => "/opt/boxen/apache-maven/apache-maven-${version}",
    require => File["/usr/boxen/apache-maven/apache-maven-${version}"];
  }
  
  file { '/opt/boxen/bin/mvn': 
    ensure => link,
    target  => '/opt/boxen/apache-maven/maven/bin/mvn',
    require => File['/opt/boxen/apache-maven/maven'];
  }

}
