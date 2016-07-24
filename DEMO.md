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
	
3. Run the script to fetch [Backblaze data files](https://www.backblaze.com/b2/hard-drive-test-data.html)

	```
	sync/bin/capture-backblaze.sh fetch
	```

4. Launch the [Flume](http://flume.apache.org) directory watcher agent

	```
	sync/bin/run-flume.sh
	```
	
5. Run the script to unpack the [Backblaze data files](https://www.backblaze.com/b2/hard-drive-test-data.html) into the directory being watched by a [Flume](http://flume.apache.org) agent

	```
	sync/bin/capture-backblaze.sh load /tmp/data_2013.zip
	```

6. Submit example workflow

	```
	sudo -u hdfs oozie job -oozie http://localhost:11000/oozie -config sync/cfg/example/job.properties -submit -D date=`date '+%Y%m%d'` 
	```

7. Start the example workflow 

	```
	sudo -u hdfs oozie job -oozie http://localhost:11000/oozie -start <oozie-workflow-id>
	```
