import unittest
from io import StringIO
from unittest.mock import Mock, MagicMock, patch
from google.cloud.speech_v1p1beta1 import SpeechClient, enums

import list_processor

class TestListProcessor(unittest.TestCase):

    @patch('sys.stdout', new_callable=StringIO)
    @patch('list_processor.SpeechClient', spec = True)
    def test_spoken_list_processor(self, mock_client, mock_stdout):
        # Setting up Cloud Function variables
        event = {
            'bucket': 'recordings-bucket',
            'name': 'some-recording',
            'metageneration': 'some-metageneration',
            'timeCreated': '0',
            'updated': '0'
        }
        context = MagicMock()
        context.event_id = 'some-id'
        context.event_type = 'gcs-event'

        # Setting up result mocks
        alternative = Mock()
        alternative.transcript = 'crema manzana y nuez'

        result = Mock()
        result.alternatives = [alternative]
        results = [result]
        
        response = Mock()
        response.results = results

        mock_client.return_value.recognize.return_value = response 
        # Testing code
        list_processor.spoken_list(event, context)

        config = {
            "language_code": "es-MX",
            "sample_rate_hertz": 44100,
            "encoding": enums.RecognitionConfig.AudioEncoding.MP3
        }
        audio = {"uri": 'gs://recordings-bucket/some-recording' }
        assert mock_client.called
        mock_client.return_value.recognize.assert_called_with(config, audio)
        assert 'crema manzana y nuez' in mock_stdout.getvalue()




if __name__ == "__main__":
    unittest.main()
