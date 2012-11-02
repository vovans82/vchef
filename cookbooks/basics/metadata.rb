maintainer       "2600hz, Inc."
maintainer_email "stephen@2600hz.com"
license          "Apache 2.0"
description      "Installs/Configures basic packages and cron entries"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version '0.0.25'
recipe		 "default", "installs basic packages"
recipe		 "reboot", "reboot host"
#depends		 "redis"
