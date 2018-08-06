#!/bin/bash

### Script installs java8 which works with Cobalt Strike

apt-get install dirmngr -y -qq
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv C2518248EEA14886
gpg --export --armor 9BDB3D89CE49EC21 | apt-key add -
apt-get update
apt-get install oracle-java8-set-default -y -qq
