
  $version = "2.45.0"
  $version_array = split($version, '[.]')
  $major_version = $version_array[0]
  $minor_version = $version_array[1]
  $release_version = $version_array[2]
  $url = "http://selenium-release.storage.googleapis.com/${major_version}.${minor_version}/selenium-server-standalone-${major_version}.${minor_version}.${release_version}.jar"
  $filename = 'selenium-$version'

  package { "xorg-x11-server-Xvfb":
    ensure => installed,
  }
  package { "firefox":
    ensure => installed,
  }
  package { "unzip":
    ensure => installed,
  }

  exec { "web-starter-selenium::download":
    command => "wget --directory-prefix=/tmp/vagrant-cache ${url}",
    path    => '/usr/bin',
    require => [ Package["java-1.7.0-openjdk"], File["/tmp/vagrant-cache"] ],
    creates => "/tmp/vagrant-cache/${filename}.tgz",
    timeout => 4800,
  }

  # extract from the solr archive
  exec { "web-starter-selenium::extract":
    command => "tar -zxvf /tmp/vagrant-cache/${filename}.tgz -C /opt",
    path    => ["/bin"],
    require => [Exec["web-starter-selenium::download"]],
    creates => "/opt/selenium-server-standalone-${version}.jar",
  }
