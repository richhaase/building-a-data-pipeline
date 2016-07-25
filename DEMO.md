# Building a data pipeline - demo

## Input Data
The demo will download hard drive failure rate data from Backblaze.  The raw data files look something like this:

	date,serial_number,model,capacity_bytes,failure,smart_1_normalized,smart_1_raw,smart_2_normalized,smart_2_raw,smart_3_normalized,smart_3_raw,smart_4_normalized,smart_4_raw,smart_5_normalized,smart_5_raw,smart_7_normalized,smart_7_raw,smart_8_normalized,smart_8_raw,smart_9_normalized,smart_9_raw,smart_10_normalized,smart_10_raw,smart_11_normalized,smart_11_raw,smart_12_normalized,smart_12_raw,smart_13_normalized,smart_13_raw,smart_15_normalized,smart_15_raw,smart_183_normalized,smart_183_raw,smart_184_normalized,smart_184_raw,smart_187_normalized,smart_187_raw,smart_188_normalized,smart_188_raw,smart_189_normalized,smart_189_raw,smart_190_normalized,smart_190_raw,smart_191_normalized,smart_191_raw,smart_192_normalized,smart_192_raw,smart_193_normalized,smart_193_raw,smart_194_normalized,smart_194_raw,smart_195_normalized,smart_195_raw,smart_196_normalized,smart_196_raw,smart_197_normalized,smart_197_raw,smart_198_normalized,smart_198_raw,smart_199_normalized,smart_199_raw,smart_200_normalized,smart_200_raw,smart_201_normalized,smart_201_raw,smart_223_normalized,smart_223_raw,smart_225_normalized,smart_225_raw,smart_240_normalized,smart_240_raw,smart_241_normalized,smart_241_raw,smart_242_normalized,smart_242_raw,smart_250_normalized,smart_250_raw,smart_251_normalized,smart_251_raw,smart_252_normalized,smart_252_raw,smart_254_normalized,smart_254_raw,smart_255_normalized,smart_255_raw
	2013-04-12,MJ0351YNG9Z0XA,Hitachi HDS5C3030ALA630,3000592982016,0,,0,,,,,,,,0,,,,,,4079,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,25,,,,,,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,
	2013-04-12,MJ0351YNG9WJSA,Hitachi HDS5C3030ALA630,3000592982016,0,,0,,,,,,,,2,,,,,,4142,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,25,,,,,,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,
	2013-04-12,MJ0351YNG9Z7LA,Hitachi HDS5C3030ALA630,3000592982016,0,,0,,,,,,,,0,,,,,,3641,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,26,,,,,,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,
	2013-04-12,MJ0351YNGAD37A,Hitachi HDS5C3030ALA630,3000592982016,0,,0,,,,,,,,0,,,,,,2381,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,27,,,,,,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,
	2013-04-12,MJ0351YNGABYAA,Hitachi HDS5C3030ALA630,3000592982016,0,,0,,,,,,,,0,,,,,,2784,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,29,,,,,,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,
	2013-04-12,MJ1311YNG7ESHA,Hitachi HDS5C3030ALA630,3000592982016,0,,0,,,,,,,,0,,,,,,8771,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,19,,,,,,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,


## Output Data
The output data from the example will be an ordered listing of failure rates by model number and disk capacity.


## Instructions

1. Clone this [repo](https://github.com/richhaase/building-a-data-pipeline.git).

	```
	git clone https://github.com/richhaase/building-a-data-pipeline.git
	cd building-a-data-pipeline
	```
	
2. Launch the demo virtual machine (this will take several minutes the first time you run it).
	
	```
	gallifrey:building-a-data-pipeline (master*) $ vagrant up
	Bringing machine 'demo' up with 'virtualbox' provider...
	==> demo: Importing base box 'centos/7'...
	==> demo: Matching MAC address for NAT networking...
	==> demo: Checking if box 'centos/7' is up to date...
	==> demo: Setting the name of the VM: building-a-data-pipeline_demo_1469470182293_19326
	==> demo: Clearing any previously set network interfaces...
	==> demo: Preparing network interfaces based on configuration...
	    demo: Adapter 1: nat
	    demo: Adapter 2: hostonly
	==> demo: Forwarding ports...
	    demo: 22 (guest) => 2222 (host) (adapter 1)
	==> demo: Running 'pre-boot' VM customizations...
	==> demo: Booting VM...
	==> demo: Waiting for machine to boot. This may take a few minutes...
	    demo: SSH address: 127.0.0.1:2222
	    demo: SSH username: vagrant
	    demo: SSH auth method: private key
	
	...
	
    ==> demo: Create OOZIE_SYS table
    ==> demo: DONE
    ==> demo: 
    ==> demo: Oozie DB has been created for Oozie version '4.2.0'
    ==> demo: 
    ==> demo: 
    ==> demo: The SQL commands have been written to: /tmp/ooziedb-5496497486988270863.sql
    ==> demo: starting historyserver, logging to /var/log/hadoop-mapreduce/mapred-mapred-historyserver-demo.out
    ==> demo: Started Hadoop historyserver:[  OK  ]
	    
	```
	
3. Login to the demo virtual machine.

	```
	gallifrey:building-a-data-pipeline (master*) $ vagrant ssh
	[vagrant@demo ~]$
	```
	
4. Run the [capture-backblaze.sh](https://github.com/richhaase/building-a-data-pipeline/blob/master/bin/capture-backblaze.sh) script to fetch [Backblaze data files](https://github.com/richhaase/building-a-data-pipeline#sample-data-provided-by-backblaze) .

	```
	demo/bin/capture-backblaze.sh fetch
	```

5. Launch the [Flume](http://flume.apache.org) directory watcher agent by running [run-flume.sh].

	```
    sudo -u mapred flume-ng agent -n pipeline -f /home/vagrant/sync/cfg/flume-agent-conf.properties
	```
	
6. Run the [capture-backblaze.sh](https://github.com/richhaase/building-a-data-pipeline/blob/master/bin/capture-backblaze.sh) script to unpack the [Backblaze data files](https://github.com/richhaase/building-a-data-pipeline#sample-data-provided-by-backblaze) into the directory being watched by a [Flume](http://flume.apache.org) agent.

	```shell
	for file in `ls /tmp/data_*.zip`; do
	    demo/bin/capture-backblaze.sh load $file
	done
	```

7. Run the example Oozie workflow.

	```
	sudo -u hdfs oozie job -oozie http://localhost:11000/oozie -config demo/cfg/example/job.properties -run -D date=`date '+%Y%m%d'` 
	```
