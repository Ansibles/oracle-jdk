#!/bin/bash

echo localhost > inventory
ansible-playbook --syntax-check -i inventory test/playbook.yml || exit 1
ansible-playbook -i inventory test/playbook.yml --connection=local -v || exit 2

source /etc/profile.d/jdk_switcher.sh || exit 3

echo "check default version:"
java -version 2>&1 | grep 'java version' | grep -wE 'java version "1.8.0_.*"' || exit 4

echo "check that expected oracle java versions are available:"
for JAVA_VERSION in 6 7 8
do
  echo "Switch to OracleJDK $JAVA_VERSION"
  jdk_switcher use oraclejdk$JAVA_VERSION
  java -version 2>&1 | grep 'java version' | grep -wE "java version \"1.${JAVA_VERSION}.0_.*\"" || exit "99${JAVA_VERSION}"
done
