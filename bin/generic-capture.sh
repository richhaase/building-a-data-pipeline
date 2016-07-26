#!/usr/bin/env bash -x
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

## Example cron entry
# */5 * * * * /usr/local/bin/capture.sh

TIMESTAMP=`date '+%Y%m%d%H%M%S'`

CAPTURE_DIR=${CAPTURE_DIR:-"/tmp"}
READY_FLAG=${READY_FLAG:-".READY"}
FILE_PATTERN=${FILE_PATTERN:-"*"}
UPLOAD_DIR=${UPLOAD_DIR:-"/user/flume/captured"}

LISTING=${CAPTURE_DIR}/${FILE_PATTERN}${READY_FLAG}
	
for file in `ls ${LISTING}`
do
  uploadfile=${UPLOAD_DIR}/${TIMESTAMP}/`basename $file $READY_FLAG`
  hdfs dfs -put $file $uploadfile 
  if [ $? -eq 0 ]
  then
    rm $file
  fi
done
