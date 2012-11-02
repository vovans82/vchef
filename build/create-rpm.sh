#!/bin/bash
#
# Create an RPM of the current chef configuration
#

BUILD_NUMBER=$1
WORKSPACE=$2

echo "Building ChooChee Chef Configuration RPM (#$BUILD_NUMBER)"
rpmbuild -bb $WORKSPACE/build/chef-configs.spec
ln -s chef-configs-0.$BUILD_NUMBER-0.noarch.rpm $WORKSPACE/build/rpmbuild/RPMS/noarch/chef-configs-latest.noarch.rpm
