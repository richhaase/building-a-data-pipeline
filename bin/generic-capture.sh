#!/usr/bin/env bash -x

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
