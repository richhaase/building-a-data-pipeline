#!/usr/bin/env bash

chmod 755 /home/vagrant

## We don't need no stinking firewall
systemctl disable firewalld
systemctl stop firewalld

## Install utilities
yum install -y wget unzip net-tools vim

## Install OpenJDK 7
yum install -y java-1.7.0-openjdk-devel

## Add Bigtop Repo
wget -O /etc/yum.repos.d/bigtop.repo http://www.apache.org/dist/bigtop/bigtop-1.1.0/repos/centos7/bigtop.repo
yum update -y

## Install Apache Hadoop psuedo cluster config
yum install -y hadoop-conf-pseudo 
yum install -y spark-core
yum install -y pig pig-udf-datafu
yum install -y oozie
yum install -y flume flume-agent

## Install ExtJs 2.2 for Oozie UI
wget -O /tmp/ext-2.2.zip http://archive.cloudera.com/gplextras/misc/ext-2.2.zip
unzip /tmp/ext-2.2.zip -d /var/lib/oozie

## Start sh*t up
sudo -u hdfs hdfs namenode -format

/etc/init.d/hadoop-hdfs-namenode start
/etc/init.d/hadoop-hdfs-datanode start
/etc/init.d/hadoop-yarn-resourcemanager start
/etc/init.d/hadoop-yarn-nodemanager start

## Setup Flume
mkdir /var/spool/flume
chown flume:flume /var/spool/flume
sudo -u hdfs hdfs dfs -mkdir -p /user/flume/in
sudo -u hdfs hdfs dfs -chown -R flume:flume /user/flume

## Setup Oozie job
sudo -u hdfs hdfs dfs -mkdir -p /user/oozie/share/lib
sudo -u hdfs hdfs dfs -chown -R oozie:oozie /user/oozie
sudo -u hdfs hdfs dfs -mkdir -p /user/hdfs/hdd/cfg
sudo -u hdfs hdfs dfs -put sync/cfg/example/* /user/hdfs/hdd/cfg
# for some reason oozie ships with commons-io-2.1, but needs commons-io-2.4 
# in order to run `oozie-setup sharelib create -fs <hdfs-path>`
# See https://mail-archives.apache.org/mod_mbox/oozie-user/201507.mbox/%3CCALBGZ8o4n27S8w6fn3HFxfzJmZbA9Gsz71Ewg+r6XEFCZTFpPQ@mail.gmail.com%3E
cp /usr/lib/hive/lib/commons-io-2.4.jar /usr/lib/oozie/lib/
oozie-setup sharelib create -fs hdfs://localhost:8020/user/oozie/share/lib
sudo -u oozie hdfs dfs -put /usr/lib/pig/lib/piggybank.jar /user/oozie/share/lib/lib_*/pig

## Start Oozie
/etc/init.d/oozie start

## Startup Job History server
sudo -u hdfs hdfs dfs -mkdir -p /tmp/hadoop-yarn/staging
sudo -u hdfs hdfs dfs -chmod -R 0777 /tmp
