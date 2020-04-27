from google.cloud.speech_v1p1beta1 import SpeechClient, enums


def spoken_list(data, context):
    """Background Cloud Function to be triggered by Cloud Storage.
       This function takes the recently created file, verifies if it's an audio file and sends it to Cloud Speech for speech-to-text recognition

    Args:
        data (dict): The Cloud Functions event payload.
        context (google.cloud.functions.Context): Metadata of triggering event.
    Returns:
        None; thr output if any is written to Stackdriver Logging
    """

    client = SpeechClient()

    # The language of the supplied audio
    language_code = "es-MX"

    # Sample rate in Hertz of the audio data sent
    sample_rate_hertz = 44100

    # Encoding of the audio data sent.
    encoding = enums.RecognitionConfig.AudioEncoding.MP3

    config = {
        "language_code": language_code,
        "sample_rate_hertz": sample_rate_hertz,
        "encoding": encoding
    }

    bucket_name = data["bucket"]
    file_name = data["name"]

    audio = {"uri": f"gs://{bucket_name}/{file_name}"}

    response = client.recognize(config, audio)

    for result in response.results:
        # First alternative is the most probable result
        alternative = result.alternatives[0]
        print(f"Transcript: {alternative.transcript}")
