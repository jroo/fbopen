#!/bin/bash


json_output_file='workfiles/notices.json'
bulk_output_file='workfiles/notices.bulk'
raw_json='workfiles/alltopics.json'

FBOPEN_URI=${FBOPEN_URI:-"localhost:9200"}
echo "FBOPEN_URI = $FBOPEN_URI"
FBOPEN_INDEX=${FBOPEN_INDEX:-"fbopen"}
echo "FBOPEN_INDEX = $FBOPEN_INDEX"

mkdir -p workfiles

echo "JSON raw file is " $raw_json

if [ -f $raw_json ];
then
    today=`date +%s`
    modified=`stat -f "%m" $raw_json`
    diff=`expr $today - $modified`
    if  (($diff > 43200));
    then 
        echo "file older than 12 hours, redownloading ..."
        python gettopics.py
    else
        echo "File exists and is recent, skipping download..."
    fi
else 
    echo "Downloading JSON dump..."
    python gettopics.py
fi

echo "Converting to JSON..." 
node process_bids.js $raw_json

echo "Converting JSON to Elasticsearch bulk format..."
cat $json_output_file | node $FBOPEN_ROOT/loaders/common/format-bulk.js -a > $bulk_output_file


# load into Elasticsearch
echo "Loading into Elasticsearch..."
curl -s -XPOST "$FBOPEN_URI/$FBOPEN_INDEX/_bulk" --data-binary @$bulk_output_file;
 echo
echo "Done loading into Elasticsearch."


echo "dodsbir.net done."

