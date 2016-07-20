#!/usr/bin/env bash

FLUME_DIR=/var/spool/flume

# Download Backblaze hard drive data files to /tmp
# https://www.backblaze.com/b2/hard-drive-test-data.html
function fetch() {
	# Data provided by Backblaze 
	# https://www.backblaze.com/b2/hard-drive-test-data.html
	#
	BBDATA=(https://f001.backblaze.com/file/Backblaze-Hard-Drive-Data/data_2013.zip
	      https://f001.backblaze.com/file/Backblaze-Hard-Drive-Data/data_2014.zip
	      https://f001.backblaze.com/file/Backblaze-Hard-Drive-Data/data_2015.zip
	      https://f001.backblaze.com/file/Backblaze-Hard-Drive-Data/data_Q1_2016.zip)

	for url in ${BBDATA[*]}
	do
		filename=`basename $url` 
		echo "Fetching $url"
		wget -O /tmp/$filename $url 
	done
}

# Unzip data files into the directory monitored by flume
function load() {
	for i in `seq 3 5`
	do
    	sudo -u flume unzip -j /tmp/data_201${i}.zip -d $FLUME_DIR
	done
	sudo -u flume unzip -j /tmp/data_Q1_2016.zip -d $FLUME_DIR
}

# Usage message
function usage() {
	echo "usage: `basename "$0"` fetch|load"
}

case $1 in
	fetch) fetch
		;;
	load) load
    	;;
    *) usage
    	;;
esac
