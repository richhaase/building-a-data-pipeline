/* enrich.pig
An example of how to parse useful data from the sequence files 
loaded by flume (and capture-backblaze.sh)
*/

REGISTER piggybank.jar
REGISTER avro-*.jar
REGISTER jackson-core-asl-*.jar
REGISTER jackson-mapper-asl-*.jar
REGISTER json-simple-*.jar
REGISTER snappy-java-*.jar

%default DATE `date "+%Y%m%d"`
raw = LOAD '/user/flume/in/$DATE' USING org.apache.pig.piggybank.storage.SequenceFileLoader();

fields = FOREACH raw GENERATE STRSPLIT($1, ',', 0);
filtered = FILTER fields BY $0.$0 != 'date';

-- date,serial_number,model,capacity_bytes,failure
useful = FOREACH filtered GENERATE ToDate($0.$0, 'yyyy-MM-dd') as date,
								   $0.$1 as serial_number,
								   $0.$2 as model,
								   $0.$3 as capacity_bytes, 
								   $0.$4 as failure; 

STORE records INTO '/user/hdfs/hdd/$DATE'
    USING org.apache.pig.piggybank.storage.avro.AvroStorage(
        '{
            "schema": {
                "type": "record",
                "name": "backblaze",
                "namespace": "com.richhaase",
                "fields": [
                    {
                        "name": "date",
                        "type": "string"
                    },
                    {
                        "name": "serial_number",
                        "type": "string"
                    },
                    {
                        "name": "model",
                        "type": "string"
                    },
                    {
                        "name": "capacity_bytes",
                        "type": "long"
                    },
                             {
                        "name": "failure",
                        "type": "int"
                    }
                ],
                "doc:" : "A simplified Backblaze HDD failure data record"
            }
        }');
