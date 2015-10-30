node default {
  include apt
  include nginx
  include php
  include mariadb

  class { ['php::fpm', 'php::cli',
    'php::extension::apc', 'php::extension::mysql', 'php::extension::gd', 'php::extension::curl', 'php::extension::redis',
    'php::extension::intl',
    'php::composer']:

  }

#
#  php::config { 'Realpath size':
#    setting => 'realpath_cache_size',
#    value   => '4096k',
#    file    => '/etc/php5/fpm/php.ini',
#    section => 'PHP',
#  }

  # Se usa el paquete porque la extension de php da error al instalarse
  package { "php5-mongo":
    ensure  => present
  }

  package { "mongodb":
    ensure  => present
  }

  package { "git":
    ensure  => present
  }

  nginx::resource::vhost{'erp.prod':
    ensure => present,
    www_root => '/var/www/erp/web',
    index_files => ['app.php'],
    try_files       => ['$uri /app.php$is_args$args']
  }

  nginx::resource::vhost{'erp.dev':
    ensure => present,
    www_root => '/var/www/erp/web',
    index_files => ['app_dev.php'],
    try_files       => ['$uri /app_dev.php$is_args$args']
  }


  nginx::resource::location { "dev":
    ensure          => present,
    vhost           => 'erp.dev',
    www_root        => '/var/www/erp/web',
    location        => '~ ^/(app_dev|config)\.php(/|$)',
    fastcgi         => "unix:/var/run/php5-fpm.sock",
    location_cfg_append => {
      fastcgi_split_path_info => '^(.+\.php)(/.*)$',
    },
    fastcgi_param  => {
      'SCRIPT_FILENAME' => '$realpath_root$fastcgi_script_name',
      'DOCUMENT_ROOT' => '$realpath_root'
    }
  }

  nginx::resource::location { "prod":
    ensure          => present,
    vhost           => 'erp.prod',
    www_root        => '/var/www/erp/web',
    location        => '~ ^/app\.php(/|$)',
    fastcgi         => "unix:/var/run/php5-fpm.sock",
    location_cfg_append => {
      fastcgi_split_path_info => '^(.+\.php)(/.*)$',
    },
    fastcgi_param  => {
      'SCRIPT_FILENAME' => '$realpath_root$fastcgi_script_name',
      'DOCUMENT_ROOT' => '$realpath_root'
    }
  }

}
