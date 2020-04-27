# Despenso

Keep your lists for groceries by telling your phone what you have in your fridge or kitchen.

**Note:** Please not this is in really early stage of development and consists of mainly proof of concept of cloud stuff as of now

## What's in here then?

A simple Google Cloud Function that will take audio files in mp3 format that you upload to a bucket, apply speech to text with Google Cloud Speech and log it to Stack Driver logs. Not much, I know, but this was built in around 3 hours from an iPad connected to a Digital Ocean droplet, so a bit of time spent setting everything up there.

Directories:

* Functions: All the functions to perform any kind of heavy lift logic.
	* Backend: Functions dedicated to Backend stuff.
* Recordings: Sample recordings in `.mp3` format. 

## ToDo

- [ ] Add Cloud Function to upload a file from an endpoint.
- [ ] Create a Mobile App to use the microphone to record and upload the samples.
- [ ] Split the audio in 15s chunks before sending to Cloud Speech.
- [ ] Accept other languages, as it is hardcodedto Mexican Spanish (es-MX).

## How do I run this?

### Requirements

1. A Google Cloud account and project where to deploy.
2. A configured GCP SDK in your local machine.
3. Python 3.9 or above.
4. A GCS bucket (private) to upload the files.

You can test the existing code by running the following within the Functions/Backend directory:

```bash
python main_test.py
```

You can deploy the current Cloud Function with:

```bash
gcloud functions deploy spoken_list --runtime python37 --trigger-resource [BUCKET] --trigger-event google.storage.object.finalize
```

Finally you can test the function by copying an mp3 file to the remote bucket.

```bash
gsutil cp Recordings/Lista-de-super.mp3 gs://[BUCKET]/
```
