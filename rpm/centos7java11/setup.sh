#!/bin/sh
set -ex

yum -y install apache-maven java-11-openjdk-devel

update-alternatives --set java $(realpath /usr/lib/jvm/java-11-openjdk/bin/java)
update-alternatives --set javac $(realpath /usr/lib/jvm/java-11-openjdk/bin/javac)

java_home=$(dirname $(dirname $(readlink -f $(which javac))))

cat > /etc/profile.d/java-home.sh <<EOF
export JAVA_HOME=${java_home}
EOF

source /etc/profile.d/java-home.sh

java -version
javac -version
mvn --version