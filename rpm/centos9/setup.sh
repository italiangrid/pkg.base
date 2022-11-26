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
yum -y install make createrepo \
  which wget rpm-build rpm-sign expect git tar \
  redhat-rpm-config rpmdevtools \
  autoconf automake cmake gcc-c++ libtool sudo

# install Java 17
yum install -y https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.rpm

# install Maven 3.8.6
curl -s http://mirrors.ibiblio.org/apache/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz | tar zx -C /opt

cat > /etc/profile.d/apache-maven.csh <<'EOF'
setenv MAVEN_HOME /opt/apache-maven-3.8.6
setenv M2_HOME $MAVEN_HOME
setenv PATH $M2_HOME/bin:$PATH
EOF
cat > /etc/profile.d/apache-maven.sh <<'EOF'
export MAVEN_HOME=/opt/apache-maven-3.8.6
export M2_HOME=$MAVEN_HOME
export PATH=$MAVEN_HOME/bin:$PATH
EOF

source /etc/profile.d/apache-maven.sh

java -version
javac -version
mvn --version

# Disable require tty which prevents to run sudo naturally
# from jenkins, where we have no tty
sed -i -e "/Defaults    requiretty/d" /etc/sudoers
sed -i -e "/Defaults   \!visiblepw/d" /etc/sudoers

# Add build user to the sudoers
echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
adduser --uid ${BUILD_USER_UID} ${BUILD_USER}
usermod -a -G wheel ${BUILD_USER}

# build user setup
mkdir ${BUILD_USER_HOME}/.m2
cp /settings.xml ${BUILD_USER_HOME}/.m2
mkdir /m2-repository
chown -R ${BUILD_USER}:${BUILD_USER} ${BUILD_USER_HOME} /m2-repository

yum clean all

# Add nexus uploader utility

curl https://baltig.infn.it/mw-devel/helper-scripts/raw/master/scripts/nexus-assets-upload -o /usr/local/bin/nexus-assets-upload
curl https://baltig.infn.it/mw-devel/helper-scripts/raw/master/scripts/nexus-assets-flat-upload -o /usr/local/bin/nexus-assets-flat-upload

chmod +x /usr/local/bin/nexus-assets-upload
chmod +x /usr/local/bin/nexus-assets-flat-upload
