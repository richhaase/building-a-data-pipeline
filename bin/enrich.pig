/* enrich.pig
An example of how to parse useful data from the sequence files 
loaded by flume (and capture-backblaze.sh)
*/

%default DATE `date "+%Y%m%d"`
raw = LOAD '/user/flume/in/$DATE' USING org.apache.pig.piggybank.storage.SequenceFileLoader();

fields = FOREACH raw GENERATE STRSPLIT($1, ',', 0);
filtered = FILTER fields BY $0.$0 != 'date';

-- date,serial_number,model,capacity_bytes,failure,smart_1_raw,smart_5_raw,smart_9_raw,smart_194_raw,smart_197_raw
useful = FOREACH filtered GENERATE ToDate($0.$0, 'yyyy-MM-dd') as date,
								   $0.$1 as serial_number,
								   $0.$2 as model,
								   $0.$3 as capacity_bytes, 
								   $0.$4 as failure, 
								   $0.$6, 
								   $0.$14, 
								   $0.$20, 
								   $0.$50, 
								   $0.$56;

-- X = LIMIT useful 10;
-- DUMP X;
-- STORE useful INTO HCatalog(blah)