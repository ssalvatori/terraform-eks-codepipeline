#!/usr/bin

curl https://download.gocd.org/gocd.repo -o /etc/yum.repos.d/gocd.repo

yum install -y java-1.8.0-openjdk.x86_64
/usr/sbin/alternatives --set java /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java
/usr/sbin/alternatives --set javac /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/javac
yum remove java-1.7

yum install -y go-server