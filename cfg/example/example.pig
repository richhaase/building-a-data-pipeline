-- example.pig

-- Copyright 2016 Rich Haase
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- An example of how to parse "useful" data from the sequence files 
-- loaded by flume (and capture-backblaze.sh)

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

-- get a tuple of fields for each sequence file row
fields = FOREACH raw GENERATE STRSPLIT($1, ',', 0);

-- filter out file headers
filtered = FILTER fields BY $0.$0 != 'date';

-- model,capacity_bytes,failure
useful = FOREACH filtered GENERATE $0.$2 as model,
                                   (long) $0.$3 / $GB as capacity_gb,
                                   (long) $0.$4 as failure;

-- group records by model and capacity
grouped_by_sn = GROUP useful BY (model, capacity_gb);

-- Count all failures by model and capacity
aggregates = FOREACH grouped_by_sn GENERATE
    FLATTEN(group) AS (model, capacity_gb),
    SUM(useful.failure) AS total_failures;

-- Sort by highest failure_rate descending
out = ORDER aggregates BY total_failures DESC;

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
--                         "name": "model",
--                         "type": "string"
--                     },
--                     {
--                         "name": "capacity_gb",
--                         "type": "int"
--                     },
--                              {
--                         "name": "failure",
--                         "type": "int"
--                     }
--                 ],
--                 "doc:" : "A simplified Backblaze HDD failure data record"
--             }
--         }');