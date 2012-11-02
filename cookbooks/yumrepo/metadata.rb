maintainer       "ChooChee Ops"
maintainer_email "ops@choochee.com"
license          "Apache 2.0"
description      "Installs and configures ChooChee yum repositories."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version '3.0.35'
recipe "yumrepo::default", "Installs ChooChee repositories."

%w{ redhat centos }.each do |os|
  supports os, ">= 5.0"
end
