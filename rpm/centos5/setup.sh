#!/bin/sh
set -ex

BUILD_USER=${BUILD_USER:-build}
BUILD_USER_UID=${BUILD_USER_UID:-1234}
BUILD_USER_HOME=${BUILD_USER_HOME:-/home/${BUILD_USER}}

# Use only GARR and CERN mirrors
echo "include_only=.garr.it,.cern.ch" >> /etc/yum/pluginconf.d/fastestmirror.conf

yum clean all
yum install -y hostname epel-release
yum -y update
yum -y install which make createrepo \
  wget rpm-build git tar java-1.7.0-openjdk-devel apache-maven \
  redhat-rpm-config buildsys-macros \
  autoconf automake cmake gcc-c++ libtool sudo

# For some reason centos5 apache-maven package does
# not set a suitable link for mvn executable, and
# this makes rpm build fail
ln -s /usr/share/apache-maven/bin/mvn /usr/bin/mvn

# Align it with centos7 naming
# sed -i -e "s#^%dist .el5#%dist .el5.centos#" /etc/rpm/macros.dist

# Disable require tty which prevents to run sudo naturally
# from jenkins, where we have no tty
sed -i -e "/Defaults    requiretty/d" /etc/sudoers
sed -i -e "/Defaults   \!visiblepw/d" /etc/sudoers

update-alternatives --set java /usr/lib/jvm/jre-1.7.0-openjdk.x86_64/bin/java
update-alternatives --set javac /usr/lib/jvm/java-1.7.0-openjdk.x86_64/bin/javac

source /etc/profile.d/apache-maven.sh

java -version
javac -version
mvn --version

# Add build user to the sudoers
echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
adduser --uid ${BUILD_USER_UID} ${BUILD_USER}
usermod -a -G wheel ${BUILD_USER}

mkdir ${BUILD_USER_HOME}/.m2
cp /settings.xml ${BUILD_USER_HOME}/.m2
mkdir /m2-repository

chown -R ${BUILD_USER}:${BUILD_USER} ${BUILD_USER_HOME} /m2-repository
yum clean all
