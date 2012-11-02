%define name		chef-configs
%define version		%{release}.%{build_number}
%define release		0
%define buildroot	%{_tmppath}/BUILD/%{name}-%{version}

BuildRoot:		%{buildroot}
BuildArch:		noarch
Packager:		ChooChee Operations
Summary:		ChooChee Chef Configurations
License:		Proprietary
Name:			%{name}
Version:		%{version}
Release:		%{release}
Prefix:			/opt
Group:			ChooChee

%description
This package contains all the configurations necessary to build a ChooChee Chef Server from scratch, including the cookbooks, recipes, and basic configuration files for services.  It should be installed after the Chef server has been installed.

%prep
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf "$RPM_BUILD_ROOT"
mkdir -p %{buildroot}/chef
cd %{buildroot}

git clone git@github.com:choochee/chef.git

tar zcf chef-%{version}.tar.gz chef

rm -rf chef

%install
mkdir -p $RPM_BUILD_ROOT/opt/choochee
install -m 644 $RPM_BUILD_ROOT/chef-%{version}.tar.gz $RPM_BUILD_ROOT/opt/choochee/chef-%{version}.tar.gz
rm -f $RPM_BUILD_ROOT/chef-%{version}.tar.gz

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf "$RPM_BUILD_ROOT"

%post
cd /opt/choochee
tar zxf /opt/choochee/chef-%{version}.tar.gz
rm -f /opt/choochee/chef-%{version}.tar.gz

%files
/opt/choochee/chef-%{version}.tar.gz
