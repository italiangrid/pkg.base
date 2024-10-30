#!/bin/sh
set -ex

# install Java 17
yum install -y java-17-openjdk-devel

# install Maven 3.9.6
curl -s https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.6/apache-maven-3.9.6-bin.tar.gz | tar zx -C /opt

cat > /etc/profile.d/apache-maven.sh <<'EOF'
export MAVEN_HOME=/opt/apache-maven-3.9.6
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