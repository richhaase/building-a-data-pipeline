#!/usr/bin/env bash

# Data provided by Backblaze 
# https://www.backblaze.com/b2/hard-drive-test-data.html
#
BBDATA=(https://f001.backblaze.com/file/Backblaze-Hard-Drive-Data/data_2013.zip
        https://f001.backblaze.com/file/Backblaze-Hard-Drive-Data/data_2014.zip
        https://f001.backblaze.com/file/Backblaze-Hard-Drive-Data/data_2015.zip)

for url in ${BBDATA[*]}
do
  filename=`basename $url` 
  echo "Fetching $url"
  wget -O /tmp/$filename $url 
done

