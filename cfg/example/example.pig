/* example.pig
An example of how to parse useful data from the sequence files
loaded by flume (and capture-backblaze.sh)
*/

REGISTER /usr/lib/pig/piggybank.jar

-- required jars for AvroStorage example
-- REGISTER avro-*.jar
-- REGISTER jackson-core-asl-*.jar
-- REGISTER jackson-mapper-asl-*.jar
-- REGISTER json-simple-*.jar
-- REGISTER snappy-java-*.jar

%default DATE `date "+%Y%m%d"`
%declare GB 1073741824

raw = LOAD '/user/mapred/in/$DATE/*' USING org.apache.pig.piggybank.storage.SequenceFileLoader();

fields = FOREACH raw GENERATE STRSPLIT($1, ',', 0);
filtered = FILTER fields BY $0.$0 != 'date';

-- date,serial_number,model,capacity_bytes,failure
useful = FOREACH filtered GENERATE $0.$1 as serial_number,
                                   $0.$2 as model,
                                   (long) $0.$3 as capacity_bytes,
                                   (long) $0.$4 as failure;

grouped_by_sn = GROUP useful BY (model, serial_number);

aggregates = FOREACH grouped_by_sn GENERATE
    FLATTEN(group) AS (model, serial_number),
    AVG(useful.capacity_bytes)/$GB AS avg_capacity_gb,
    SUM(useful.failure) AS total_failure;

out = ORDER aggregates BY total_failure DESC;

STORE out INTO '/user/mapred/hdd/$DATE' USING PigStorage();



-- AvroStorage example adapted from:
-- https://github.com/miguno/avro-hadoop-starter#Examples-Pig
--
-- STORE useful INTO '/user/hdfs/hdd/$DATE'
--     USING org.apache.pig.piggybank.storage.avro.AvroStorage(
--         '{
--             "schema": {
--                 "type": "record",
--                 "name": "backblaze",
--                 "namespace": "com.richhaase",
--                 "fields": [
--                     {
--                         "name": "date",
--                         "type": "string"
--                     },
--                     {
--                         "name": "serial_number",
--                         "type": "string"
--                     },
--                     {
--                         "name": "model",
--                         "type": "string"
--                     },
--                     {
--                         "name": "capacity_bytes",
--                         "type": "long"
--                     },
--                              {
--                         "name": "failure",
--                         "type": "int"
--                     }
--                 ],
--                 "doc:" : "A simplified Backblaze HDD failure data record"
--             }
--         }');