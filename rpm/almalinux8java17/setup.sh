#!/bin/sh
set -ex

BUILD_USER=${BUILD_USER:-build}
BUILD_USER_UID=${BUILD_USER_UID:-1234}
BUILD_USER_HOME=${BUILD_USER_HOME:-/home/${BUILD_USER}}

# Use only GARR and CERN mirrors
echo "include_only=.garr.it,.cern.ch" >> /etc/yum/pluginconf.d/fastestmirror.conf

dnf clean all
dnf install -y hostname epel-release yum-utils
dnf -y update

dnf config-manager --enable powertools

dnf -y install \
  autoconf \
  autoconf-archive \
  automake \
  bison \
  boost-devel \
  CGSI-gSOAP-devel \
  cmake \
  createrepo \
  diffutils \
  doxygen \
  expect \
  file \
  gcc-c++ \
  gdb \
  git \
  globus-common-devel \
  gsoap-devel \
  libtool \
  libuuid-devel \
  make \
  mariadb-devel \
  openssl-devel \
  redhat-rpm-config \
  rpm-build \
  rpm-sign \
  rpmdevtools \
  tar \
  sudo \
  wget \
  which

# install Java 17
dnf install -y java-17-openjdk-devel

# install Maven 3.8.6
curl -s https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.8.6/apache-maven-3.8.6-bin.tar.gz | tar zx -C /opt

cat > /etc/profile.d/apache-maven.sh <<'EOF'
export MAVEN_HOME=/opt/apache-maven-3.8.6
export M2_HOME=$MAVEN_HOME
export PATH=$MAVEN_HOME/bin:$PATH
EOF

source /etc/profile.d/apache-maven.sh

java_home=$(dirname $(dirname $(readlink -f $(which javac))))

cat > /etc/profile.d/java-home.sh <<EOF
export JAVA_HOME=${java_home}
EOF

source /etc/profile.d/java-home.sh

java -version
javac -version
mvn --version
echo "JAVA_HOME = ${JAVA_HOME}"

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