# Importing bids.state.gov data into FBOpen using the loader

### Limitations
The loader currently loads topics but does not load questions and answers associated with a topic. It refreshes all notices each run.

### Prerequisites
* Python >= 2.7
* Node
* wget

### Install requirements
From the `loaders/dodsbir.net` directory:

```
$ pip install -r requirements.txt
$ npm install
$ (cd ../common/ && npm install)
```

### Environment

You'll need to set the `FBOPEN_ROOT` environment variable in order to run the script.

```
$ FBOPEN_ROOT=~/projects/fbopen
```

We suggest using a tool like [autoenv](https://github.com/groovecoder/autoenv) to manage these variables.

### Run dodsbir scraper
```
$ python gettopics.py
```

### Run the loader
```
$ dodsbir-nightly.sh
```

That's it! You may need to create a workfiles directory for the first run. 
