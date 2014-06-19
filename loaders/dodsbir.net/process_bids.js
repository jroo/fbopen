var datasource_id = 'dodsbir.net';
var fs = require('fs');
var sha1 = require('sha1');

var infile = process.argv[2] || 'workfiles/alltopics.json';
var outfile = process.argv[3] || 'workfiles/notices.json';
var field_map = {
	  'title': 'title'
	, 'description': 'description'
	, 'url': 'listing_url'
    , 'proposals_begin_date': 'start_dt'
    , 'proposals_end_date': 'close_dt'
  , 'topic_number': 'solnbr'
};

var data = JSON.parse(fs.readFileSync(infile, "utf-8"));
var bids = data;
var es_data = [];

bids.forEach(function(bid){
    
    var b = bid;
    var bid_obj = { 'ext': {} };

    for (var field in b){
        if (field in field_map){
            bid_obj[field_map[field]] = b[field];
        } else {
            bid_obj['ext'][field] = b[field];
        }
    }
    
    bid_obj['id'] = sha1( b['topic_number'] + ':' + b['title']);
    bid_obj['data_source'] = datasource_id;
    //bid_obj['posted_dt'] = new Date(bid_obj['posted_dt']);

    es_data.push(JSON.stringify(bid_obj));
});

var text = es_data.join('\n');
fs.writeFile(outfile, text);

