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
The output data from the example will be an ordered listing of failure rates by model number and disk capacity.  The column headings (if they existed) would be model, capacity in GB, total failures.

    ST3000DM001	2794	266
    ST31500541AS	1397	123
    ST31500341AS	1397	91
    ST1500DL003	1397	51
    ST4000DM000	3726	48
    Hitachi HDS722020ALA330	1863	28
    Hitachi HDS5C3030ALA630	2794	26
    Hitachi HDS5C4040ALE630	3726	23
    WDC WD30EZRX	2794	17
    ST32000542AS	1863	14
    WDC WD10EADS	931	12

## Instructions

1. Clone this [repo](https://github.com/richhaase/building-a-data-pipeline.git).

	```
	git clone https://github.com/richhaase/building-a-data-pipeline.git
	```

	```
    Cloning into 'building-a-data-pipeline'...
    remote: Counting objects: 232, done.
    remote: Compressing objects: 100% (67/67), done.
    remote: Total 232 (delta 33), reused 0 (delta 0), pack-reused 165
    Receiving objects: 100% (232/232), 39.09 KiB | 0 bytes/s, done.
    Resolving deltas: 100% (121/121), done.
    Checking connectivity... done.
    ```

    ```
    cd building-a-data-pipeline
    ```

    ```
    gallifrey:building-a-data-pipeline (master) $ ls
    DEMO.md     LICENSE     README.md   Vagrantfile bin         cfg
	```

2. Launch the demo virtual machine (this will take several minutes the first time you run it).
	
	```
	vagrant up
	```

	```
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

    * [Namenode Web UI after VM Setup](https://github.com/richhaase/building-a-data-pipeline/blob/master/DEMO.md#namenode-web-ui-after-vm-setup)
    * [Resource Manager Web UI after VM setup](https://github.com/richhaase/building-a-data-pipeline/blob/master/DEMO.md#resource-manager-web-ui-after-vm-setup)
    * [Oozie Web UI after VM setup](https://github.com/richhaase/building-a-data-pipeline/blob/master/DEMO.md#oozie-web-ui-after-vm-setup)

3. Login to the demo virtual machine.

	```
	vagrant ssh
	```
	
	```
	[vagrant@demo ~]$
	```
	
4. Run the [capture-backblaze.sh](https://github.com/richhaase/building-a-data-pipeline/blob/master/bin/capture-backblaze.sh) script to fetch [Backblaze data files](https://github.com/richhaase/building-a-data-pipeline#sample-data-provided-by-backblaze) .

	```
	sync/bin/capture-backblaze.sh fetch
	```
	
	```
    Fetching https://f001.backblaze.com/file/Backblaze-Hard-Drive-Data/data_2013.zip
    --2016-07-25 23:48:30--  https://f001.backblaze.com/file/Backblaze-Hard-Drive-Data/data_2013.zip
    Resolving f001.backblaze.com (f001.backblaze.com)... 162.244.61.204
    Connecting to f001.backblaze.com (f001.backblaze.com)|162.244.61.204|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 81244724 (77M) [application/zip]
    Saving to: ‘/tmp/data_2013.zip’
    
    100%[================================================>] 81,244,724   846KB/s   in 40s    
    
    2016-07-25 23:49:11 (1.94 MB/s) - ‘/tmp/data_2013.zip’ saved [81244724/81244724]
    
    Fetching https://f001.backblaze.com/file/Backblaze-Hard-Drive-Data/data_2014.zip
    --2016-07-25 23:49:11--  https://f001.backblaze.com/file/Backblaze-Hard-Drive-Data/data_2014.zip
    Resolving f001.backblaze.com (f001.backblaze.com)... 162.244.61.204
    Connecting to f001.backblaze.com (f001.backblaze.com)|162.244.61.204|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 587251635 (560M) [b2/x-auto]
    Saving to: ‘/tmp/data_2014.zip’
    
    100%[================================================>] 587,251,635 1.95MB/s   in 5m 24s 
    
    2016-07-25 23:54:35 (1.73 MB/s) - ‘/tmp/data_2014.zip’ saved [587251635/587251635]
    
    Fetching https://f001.backblaze.com/file/Backblaze-Hard-Drive-Data/data_2015.zip
    --2016-07-25 23:54:35--  https://f001.backblaze.com/file/Backblaze-Hard-Drive-Data/data_2015.zip
    Resolving f001.backblaze.com (f001.backblaze.com)... 162.244.61.204
    Connecting to f001.backblaze.com (f001.backblaze.com)|162.244.61.204|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 842943845 (804M) [b2/x-auto]
    Saving to: ‘/tmp/data_2015.zip’
    
    100%[================================================>] 842,943,845 1.99MB/s   in 5m 48s 
    
    2016-07-26 00:00:25 (2.31 MB/s) - ‘/tmp/data_2015.zip’ saved [842943845/842943845]
    
    Fetching https://f001.backblaze.com/file/Backblaze-Hard-Drive-Data/data_Q1_2016.zip
    --2016-07-26 00:00:25--  https://f001.backblaze.com/file/Backblaze-Hard-Drive-Data/data_Q1_2016.zip
    Resolving f001.backblaze.com (f001.backblaze.com)... 162.244.61.204
    Connecting to f001.backblaze.com (f001.backblaze.com)|162.244.61.204|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 270281889 (258M) [application/zip]
    Saving to: ‘/tmp/data_Q1_2016.zip’
    
    100%[================================================>] 270,281,889 3.16MB/s   in 1m 48s 
    
    2016-07-26 00:02:14 (2.38 MB/s) - ‘/tmp/data_Q1_2016.zip’ saved [270281889/270281889]
	```

5. Launch the [Flume](http://flume.apache.org) directory watcher agent.

	```
    sudo -u mapred flume-ng agent -n pipeline -f /home/vagrant/sync/cfg/flume-agent-conf.properties
    ```

    ```
    Warning: No configuration directory set! Use --conf <dir> to override.
    Info: Including Hadoop libraries found via (/bin/hadoop) for HDFS access
    Info: Excluding /usr/lib/hadoop/lib/slf4j-api-1.7.10.jar from classpath
    Info: Excluding /usr/lib/hadoop/lib/slf4j-log4j12-1.7.10.jar from classpath
    Info: Including HBASE libraries found via (/bin/hbase) for HBASE access
    Info: Excluding /usr/lib/hbase/lib/slf4j-api-1.6.1.jar from classpath
    Info: Excluding /usr/lib/hadoop/lib/slf4j-api-1.7.10.jar from classpath
    Info: Excluding /usr/lib/hadoop/lib/slf4j-log4j12-1.7.10.jar from classpath
    Info: Excluding /usr/lib/zookeeper/lib/slf4j-api-1.6.1.jar from classpath
    Info: Excluding /usr/lib/zookeeper/lib/slf4j-log4j12-1.6.1.jar from classpath
    Info: Including Hive libraries found via () for Hive access
    
    ...
    
    16/07/25 23:59:29 INFO node.PollingPropertiesFileConfigurationProvider: Configuration provider starting
    16/07/25 23:59:29 INFO node.PollingPropertiesFileConfigurationProvider: Reloading configuration file:/home/vagrant/sync/cfg/flume-agent-conf.properties

    ... 
    
    16/07/25 23:59:29 INFO conf.FlumeConfiguration: Added sinks: hdfssink Agent: pipeline
    
    ... 
    
    16/07/25 23:59:29 INFO conf.FlumeConfiguration: Post-validation flume configuration contains configuration for agents: [pipeline]
    16/07/25 23:59:29 INFO node.AbstractConfigurationProvider: Creating channels
    16/07/25 23:59:29 INFO channel.DefaultChannelFactory: Creating instance of channel memchannel type memory
    16/07/25 23:59:29 INFO node.AbstractConfigurationProvider: Created channel memchannel
    16/07/25 23:59:29 INFO source.DefaultSourceFactory: Creating instance of source spoolsrc, type spooldir
    16/07/25 23:59:29 INFO sink.DefaultSinkFactory: Creating instance of sink: hdfssink, type: hdfs
    16/07/25 23:59:29 INFO node.AbstractConfigurationProvider: Channel memchannel connected to [spoolsrc, hdfssink]
    16/07/25 23:59:29 INFO node.Application: Starting new configuration:{ sourceRunners:{spoolsrc=EventDrivenSourceRunner: { source:Spool Directory source spoolsrc: { spoolDir: /var/spool/flume } }} sinkRunners:{hdfssink=SinkRunner: { policy:org.apache.flume.sink.DefaultSinkProcessor@22d03fac counterGroup:{ name:null counters:{} } }} channels:{memchannel=org.apache.flume.channel.MemoryChannel{name: memchannel}} }
    16/07/25 23:59:29 INFO node.Application: Starting Channel memchannel
    16/07/25 23:59:29 INFO node.Application: Waiting for channel: memchannel to start. Sleeping for 500 ms
    16/07/25 23:59:29 INFO instrumentation.MonitoredCounterGroup: Monitored counter group for type: CHANNEL, name: memchannel: Successfully registered new MBean.
    16/07/25 23:59:29 INFO instrumentation.MonitoredCounterGroup: Component type: CHANNEL, name: memchannel started
    16/07/25 23:59:30 INFO node.Application: Starting Sink hdfssink
    16/07/25 23:59:30 INFO node.Application: Starting Source spoolsrc
    16/07/25 23:59:30 INFO source.SpoolDirectorySource: SpoolDirectorySource source starting with directory: /var/spool/flume
    16/07/25 23:59:30 INFO instrumentation.MonitoredCounterGroup: Monitored counter group for type: SINK, name: hdfssink: Successfully registered new MBean.
    16/07/25 23:59:30 INFO instrumentation.MonitoredCounterGroup: Component type: SINK, name: hdfssink started
    16/07/25 23:59:30 INFO instrumentation.MonitoredCounterGroup: Monitored counter group for type: SOURCE, name: spoolsrc: Successfully registered new MBean.
    16/07/25 23:59:30 INFO instrumentation.MonitoredCounterGroup: Component type: SOURCE, name: spoolsrc started

    
    ```
    
6. Run the [capture-backblaze.sh](https://github.com/richhaase/building-a-data-pipeline/blob/master/bin/capture-backblaze.sh) script to unpack the [Backblaze data files](https://github.com/richhaase/building-a-data-pipeline#sample-data-provided-by-backblaze) into the directory being watched by a [Flume](http://flume.apache.org) agent.

	```shell
	for file in `ls /tmp/data_*.zip`; do sync/bin/capture-backblaze.sh load $file; done
	```

	```
    Archive:  /tmp/data_2013.zip
      inflating: /var/spool/flume/2013-10-17.csv  
      inflating: /var/spool/flume/2013-10-20.csv  
      inflating: /var/spool/flume/2013-09-01.csv  
      
    ...
       
    caution: excluded filename not matched:  */\.*
    Archive:  /tmp/data_2014.zip
      inflating: /var/spool/flume/2014-06-14.csv  
      inflating: /var/spool/flume/2014-12-31.csv
    
    ...
      
	```

    * Sample [Flume](http://flume.apache.org) logs while processing files added to `/var/spool/flume`
    
    ```
    16/07/26 00:16:49 INFO hdfs.BucketWriter: Creating /user/mapred/in/20160726/backblaze.1469492192427.seq.tmp
    16/07/26 00:16:49 INFO avro.ReliableSpoolingFileEventReader: Last read was never committed - resetting mark position.
    16/07/26 00:16:56 INFO avro.ReliableSpoolingFileEventReader: Last read took us just up to a file boundary. Rolling to the next file, if there is one.
    16/07/26 00:16:56 INFO avro.ReliableSpoolingFileEventReader: Preparing to delete file /var/spool/flume/2013-06-07.csv
    
    ...
     
    16/07/26 00:19:20 INFO avro.ReliableSpoolingFileEventReader: Preparing to delete file /var/spool/flume/2013-07-28.csv
    16/07/26 00:19:22 INFO avro.ReliableSpoolingFileEventReader: Last read took us just up to a file boundary. Rolling to the next file, if there is one.
    16/07/26 00:19:22 INFO avro.ReliableSpoolingFileEventReader: Preparing to delete file /var/spool/flume/2013-07-29.csv
    16/07/26 00:19:23 INFO hdfs.BucketWriter: Closing /user/mapred/in/20160726/backblaze.1469492192427.seq.tmp
    16/07/26 00:19:23 INFO hdfs.BucketWriter: Renaming /user/mapred/in/20160726/backblaze.1469492192427.seq.tmp to /user/mapred/in/20160726/backblaze.1469492192427.seq
    16/07/26 00:19:23 INFO hdfs.BucketWriter: Creating /user/mapred/in/20160726/backblaze.1469492192428.seq.tmp
    16/07/26 00:19:25 INFO avro.ReliableSpoolingFileEventReader: Last read took us just up to a file boundary. Rolling to the next file, if there is one.
    16/07/26 00:19:25 INFO avro.ReliableSpoolingFileEventReader: Preparing to delete file /var/spool/flume/2013-07-30.csv
    16/07/26 00:19:26 INFO avro.ReliableSpoolingFileEventReader: Last read took us just up to a file boundary. Rolling to the next file, if there is one.
    
    ...
    
    16/07/26 00:43:55 INFO avro.ReliableSpoolingFileEventReader: Last read took us just up to a file boundary. Rolling to the next file, if there is one.
    16/07/26 00:43:55 INFO avro.ReliableSpoolingFileEventReader: Preparing to delete file /var/spool/flume/2016-03-30.csv
    16/07/26 00:43:57 INFO avro.ReliableSpoolingFileEventReader: Last read took us just up to a file boundary. Rolling to the next file, if there is one.
    16/07/26 00:43:57 INFO avro.ReliableSpoolingFileEventReader: Preparing to delete file /var/spool/flume/2016-03-31.csv
    16/07/26 00:45:00 INFO hdfs.BucketWriter: Closing idle bucketWriter /user/mapred/in/20160726/backblaze.1469492192443.seq.tmp at 1469493900581
    16/07/26 00:45:00 INFO hdfs.BucketWriter: Closing /user/mapred/in/20160726/backblaze.1469492192443.seq.tmp
    16/07/26 00:45:00 INFO hdfs.BucketWriter: Renaming /user/mapred/in/20160726/backblaze.1469492192443.seq.tmp to /user/mapred/in/20160726/backblaze.1469492192443.seq
    16/07/26 00:45:00 INFO hdfs.HDFSEventSink: Writer callback called.
    ```

7. Run the example Oozie workflow .

	```
    sudo -u mapred oozie job -oozie http://localhost:11000/oozie -config sync/cfg/example/job.properties -run -D date=<YYYYMMDD>
    ```

    ```
    SLF4J: Class path contains multiple SLF4J bindings.
    SLF4J: Found binding in [jar:file:/usr/lib/oozie/lib/slf4j-log4j12-1.6.6.jar!/org/slf4j/impl/StaticLoggerBinder.class]
    SLF4J: Found binding in [jar:file:/usr/lib/oozie/lib/slf4j-simple-1.6.6.jar!/org/slf4j/impl/StaticLoggerBinder.class]
    SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
    SLF4J: Actual binding is of type [org.slf4j.impl.Log4jLoggerFactory]
    log4j:WARN No appenders could be found for logger (org.apache.hadoop.security.authentication.client.KerberosAuthenticator).
    log4j:WARN Please initialize the log4j system properly.
    log4j:WARN See http://logging.apache.org/log4j/1.2/faq.html#noconfig for more info.
    job: 0000000-160725232740849-oozie-oozi-W
    ```

## Screenshots

### Namenode Web UI after VM setup
![alt text](https://github.com/richhaase/building-a-data-pipeline/raw/master/img/namenode1.png "Namenode on initial startup")

### Resource Manager Web UI after VM setup
![alt text](https://github.com/richhaase/building-a-data-pipeline/raw/master/img/resourcemanager1.png "Resource Manager on initial startup")

### Oozie Web UI after VM setup 
![alt text](https://github.com/richhaase/building-a-data-pipeline/raw/master/img/oozie1.png "Oozie Web UI on initial startup")

### Resource Manager view of a running Pig job
![alt text](https://github.com/richhaase/building-a-data-pipeline/raw/master/img/running-pig-job1.png "Running Pig job")