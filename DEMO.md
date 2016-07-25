# Building a data pipeline - demo

## Instructions

1. Launch the demo virtual machine
	
	```
	vagrant up
	```
	
2. Login to the demo virtual machine

	```
	vagrant ssh
	```

3. Set `yarn.scheduler.capacity.maximum-am-resource-percent` to `0.6` in `/etc/hadoop/conf/capacity-scheduler.xml` and restart the resourcemanager.  This tells the resourcemanager to allow application masters to use as much as 60% of cluster resources.  We need to do this because our demo involes one very small server and running more than 1 application master at a time with the default configuration value of `0.1` will never allow our Oozie and Pig application masters to run at the same time. 
	
4. Run the script to fetch [Backblaze data files](https://www.backblaze.com/b2/hard-drive-test-data.html)

	```
	sync/bin/capture-backblaze.sh fetch
	```

5. Launch the [Flume](http://flume.apache.org) directory watcher agent

	```
	sync/bin/run-flume.sh
	```
	
6. Run the script to unpack the [Backblaze data files](https://www.backblaze.com/b2/hard-drive-test-data.html) into the directory being watched by a [Flume](http://flume.apache.org) agent

	```
	sync/bin/capture-backblaze.sh load /tmp/data_2013.zip
	```

7. Submit example workflow

	```
	sudo -u hdfs oozie job -oozie http://localhost:11000/oozie -config sync/cfg/example/job.properties -submit -D date=`date '+%Y%m%d'` 
	```

8. Start the example workflow 

	```
	sudo -u hdfs oozie job -oozie http://localhost:11000/oozie -start <oozie-workflow-id>
	```
	
9. Run pig script directly

	```
	sudo -u mapred pig -f sync/cfg/example/example.pig [-p DATE=YYYYMMDD]
	```
