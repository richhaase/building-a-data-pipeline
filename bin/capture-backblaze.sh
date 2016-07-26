#!/usr/bin/env bash
# Copyright 2016 Rich Haase
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

function unzip_file() {
	sudo -u mapred unzip -o -j $1 -d $FLUME_DIR -x "*/\.*"
}

# Usage message
function usage() {
echo "usage: `basename "$0"` fetch|load [file]"
}

case $1 in
	fetch) fetch
		;;
	load) unzip_file $2
    	;;
    *) usage
    	;;
esac
