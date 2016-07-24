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

4. Start a screen session

	```
	screen -S demo
	```

5. Launch the [Flume](http://flume.apache.org) directory watcher agent

	```
	sync/bin/run-flume.sh
	```

6. Open a new screen window

	```
	<Ctrl-a>c
	```
	
7. Run the script to unpack the [Backblaze data files](https://www.backblaze.com/b2/hard-drive-test-data.html) into the directory being watched by a [Flume](http://flume.apache.org) agent

	```
	sync/bin/capture-backblaze.sh load
	```

8. Submit Oozie workflow

	```
	sudo -u hdfs oozie job -oozie http://localhost:11000/oozie -config sync/cfg/enrich/job.properties -submit
	```

9. Start the workflow 

	```
	sudo -u hdfs oozie job -oozie http://localhost:11000/oozie -start <oozie-workflow-id>
	```
	
