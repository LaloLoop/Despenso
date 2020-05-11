# Despenso

Keep your lists for groceries by telling your phone what you have in your fridge or kitchen.

**Note:** Please not this is in really early stage of development and consists of mainly proof of concept of cloud stuff as of now.

## Contents of this repo

* A simple Google Cloud Function: It will take audio files in mp3 format that you upload to a bucket, apply speech to text with Google Cloud Speech and log it to Stack Driver logs. Not much, I know, but this was built in around 3 hours from an iPad connected to a Digital Ocean droplet, so a bit of time spent setting everything up there.
* An iOS app: Basic iOS app written in Swift 5 and SwiftUI, using Unit and UI tests, mainly managed with [fastlane](http://fastlane.tools).

Directories:

* Functions: All the functions to perform any kind of heavy lift logic.
  * Backend: Functions dedicated to Backend stuff.
* Recordings: Sample recordings in `.mp3` format.
* MobileApps: Contains the different mobile applications for the project.
* MobileApps/iOS: Meant to store iOS applications
* MobileApps/iOS/Despenso: The current iOS app to record and track your groceries.

## ToDo

See the current [GitHub project](https://github.com/LaloLoop/Despenso/projects/1) for more details on planned features.

## How to run it

### Requirements

1. A Google Cloud account and project where to deploy.
2. A configured GCP SDK in your local machine.
3. Python 3.9 or above.
4. A GCS bucket (private) to upload the files.
5. Fastlane running in your machine for local dev (See [setup fastlane](#setup-fastlane) section)

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

## Setup fastlane

1. Install [rvm](https://rvm.io/rvm/install) in your dev machine, this should also get you the latest ruby version.
2. Install bundler with `gem install bundler`.
3. [Install fastlane](MobileApps/iOS/Despenso/fastlane/README.md), since you are using rvm now, you should pick the `gem install` option.