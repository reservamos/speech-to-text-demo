# Speech to Text

### ⭐️ Overview

Speech to text technology, also known as voice recognition, is the ability of a computer to **recognize and transcribe spoken language into written text**. This technology has come a long way in recent years, with improvements in accuracy, speed, and ease of use.

One of the primary applications of speech to text technology is in the field of accessibility. For people with hearing or speech impairments, speech to text can provide a way to communicate more easily with others, whether in person or over the phone. Additionally, speech to text can be a valuable tool for individuals with dyslexia or other reading difficulties.

Another popular use case for speech to text is in the field of transcription. Rather than having to manually transcribe audio recordings, speech to text technology can quickly and accurately convert spoken words into text. This can save time and increase efficiency for journalists, researchers, and other professionals who need to transcribe interviews, speeches, or other types of recordings.

Overall, speech to text technology has the potential to make communication more accessible and efficient for a wide range of individuals and industries. As the technology continues to improve, we can expect to see even more innovative applications in the years to come.

### 🤖 Whisper model

---

The **whisper model** is a type of speech recognition model that uses neural networks to transcribe speech. It is designed to be more efficient and accurate than traditional models, and can be particularly effective in noisy environments where other models may struggle to recognize speech.

More information about of Whisper model: [https://openai.com/research/whisper](https://openai.com/research/whisper)

### 🤔 what can Whisper do?

---

The speech to text API provides two endpoints, **`transcriptions`** and **`translations`**, based on our state-of-the-art open source large-v2 Whisper model. They can be used to:

- Transcribe audio into whatever language the audio is in.
- Translate and transcribe the audio into english (Very good for standardize prompts starting from different audio inputs, by example: audio from our customers from Latin America and Brazil).

### ⛔️ Whisper limitations

---

- Audio file uploads are currently limited to **25 MB**.
- Supported audio file types : **`mp3`**, **`mp4`**, **`mpeg`**, **`mpga`**, **`m4a`**, **`wav`**, and **`webm`**.
- Supported languages: [https://platform.openai.com/docs/guides/speech-to-text/supported-languages](https://platform.openai.com/docs/guides/speech-to-text/supported-languages)

### 🙌🏻 Hands on

---

1. Get an audio file from the customer prompt, we can do this task using a lot of libraries for web/desktop apps or mobile apps:

   - Flutter Record - [https://pub.dev/packages/record](https://pub.dev/packages/record)
   - React Native - [https://www.npmjs.com/package/react-native-audio-recorder-player](https://www.npmjs.com/package/react-native-audio-recorder-player)
   - React JS - [https://www.npmjs.com/package/react-audio-voice-recorder](https://www.npmjs.com/package/react-audio-voice-recorder)
   - Native Android - [https://developer.android.com/guide/topics/media/mediarecorder](https://developer.android.com/guide/topics/media/mediarecorder)
   - Native iOS - [https://developer.apple.com/documentation/avfaudio/avaudiorecorder](https://developer.apple.com/documentation/avfaudio/avaudiorecorder)

1. Get an OpenAI api key: [https://platform.openai.com/account/api-keys](https://platform.openai.com/account/api-keys)
1. Make a request to get the transcription from the audio file

   > ℹ️ _We can use a terminal to test the request_

   ## Transcriptions

   - Transcription request

     ```bash
     curl --request POST \
       --url https://api.openai.com/v1/audio/transcriptions \
       --header 'Authorization: Bearer TOKEN' \
       --header 'Content-Type: multipart/form-data' \
       --form 'file=@"/path/to/file/audio-file.mp3"' \
       --form 'model="whisper-1"'
     ```

     We can add more data to request, by example add a parameter for specify audio language and add a **`prompt`** to maintain the context of conversation or guide to the language model about of the audio context.

     > ℹ️ The **[prompt](https://platform.openai.com/docs/guides/speech-to-text/prompting)** should match the audio language

     ```bash
     curl --location 'https://api.openai.com/v1/audio/transcriptions' \
     --header 'Authorization: Bearer TOKEN' \
     --header 'Content-Type: multipart/form-data' \
     --form 'file=@"/Users/ernestovm/Desktop/gdl-cdmx-20-may.m4a"' \
     --form 'model="whisper-1"' \
     --form 'language="es"' \
     --form 'prompt="el audio es referente a la busqueda de un viaje, en la cual puedes extraer el origen, destino y fecha"'
     ```

   - Transcription response
     ```json
     {
       "text": "Quiero viajar de Guadalajara a Ciudad de México el 20 de mayo"
     }
     ```

   ## Translations

   - Translation request

     ```bash
     curl --request POST \
       --url https://api.openai.com/v1/audio/translations \
     	--form 'file=@"/Users/ernestovm/Desktop/gdl-cdmx-20-may.m4a"' \
     	--form 'model="whisper-1"'
     ```

     Optionally we can add a **`prompt`** to maintain the context of conversation or guide to the language model about of the audio context.

     > ℹ️ The **[prompt](https://platform.openai.com/docs/guides/speech-to-text/prompting)** should be in English.

     ```bash
     curl --request POST \
       --url https://api.openai.com/v1/audio/translations \
     	--form 'file=@"/Users/ernestovm/Desktop/gdl-cdmx-20-may.m4a"' \
     	--form 'model="whisper-1"' \
     	--form 'prompt="the audio refers to the search for a trip, in which you can extract the origin, destination and date"'
     ```

   - Translation response
     ```bash
     {
         "text": "I want to travel from Guadalajara to Mexico City on May 20"
     }
     ```

### 🍯 Give me the honey, baby 🐝

---

In last days i did created a flutter app demo to learn how to must be the flow explained above and it is very easy to implement, in few steps all is ready

1. Get the audio record file:

   ```dart
   Future<void> startRecord() async {
       Directory tmpDir = await getTemporaryDirectory();
       String audioPath = '${tmpDir.path}/${Constants.audioFile}';
       transcription.sink.add('');
       isValidTranscription.sink.add(false);

       if (await _record.hasPermission()) {
         await _record.start(
           path: audioPath,
           encoder: AudioEncoder.aacLc,
           bitRate: 128000,
           samplingRate: 44100,
         );
       }
     }
   ```

1. Get the transcription:

   ```dart
   Future<void> getOpenAITranscription() async {
       Map<String, String> headers = {
         'Authorization': 'Bearer ${const String.fromEnvironment('API_KEY')}'
       };

       MultipartRequest request = MultipartRequest(
         'POST',
         Uri(
           scheme: 'https',
           host: Constants.openAIHost,
           path: Constants.openAITranscriptionEndpoint,
         ),
       );

       request.fields.addAll({
         'model': Constants.openAITranscriptionModel,
         'language': Constants.openAIAudioLanguage,
         'prompt': Constants.openAIPropmt
       });

       Directory tmpDir = await getTemporaryDirectory();
       String audioPath = '${tmpDir.path}/${Constants.audioFile}';

       request.files.add(await MultipartFile.fromPath(
         'file',
         audioPath,
         filename: Constants.audioFile,
       ));

       request.headers.addAll(headers);

       try {
         isLoading.sink.add(true);
         StreamedResponse response = await request.send();

         if (response.statusCode == 200) {
           final data = jsonDecode(await response.stream.bytesToString());
           TranscriptionResponse transcript = TranscriptionResponse.fromJson(data);
           transcription.sink.add('"${transcript.text}"');
           log(transcript.text, name: 'openai-transcription');
           getOpenAIChatResponse(transcript.text);
         } else {
           log(response.reasonPhrase.toString());
         }
       } on Exception catch (ex) {
         log(ex.toString());
       } finally {
         isLoading.sink.add(false);
       }
     }
   ```

1. What we doing with the transcription? 🤷🏻‍♂️

   We can chain the transcription with **[ChatGPT completions](https://platform.openai.com/docs/api-reference/making-requests)** to validate or get some util data from the audio recorded, the magic is in the chat prompt

   Context about the chat prompt:

   ```dart
   //constants.dart
   static String openAIChatPropmt(String text) =>
         'puedes extraer el origen, el destino y fecha de la siguiente cadena de texto: $text';
   ```

   Making the chat request with the **`text`** from the transcription response:

   ```dart
   Future<void> getOpenAIChatResponse(String text) async {
       Map<String, String> headers = {
         'Content-Type': 'application/json',
         'Authorization': 'Bearer ${const String.fromEnvironment('API_KEY')}'
       };

       Request request = Request(
         'POST',
         Uri(
           scheme: 'https',
           host: Constants.openAIHost,
           path: Constants.openAIChatEndpoint,
         ),
       );

       request.body = jsonEncode({
         "model": Constants.openAIChatModel,
         "messages": [
           {
             "role": "user",
             "content": Constants.openAIChatPropmt(text),
           }
         ]
       });

       request.headers.addAll(headers);

       try {
         isLoading.sink.add(true);
         StreamedResponse response = await request.send();

         if (response.statusCode == 200) {
           final data = jsonDecode(await response.stream.bytesToString());
           ChatResponse chatResponse = ChatResponse.fromJson(data);
           log(chatResponse.choices.first.message.content.replaceAll('\n', ', '),
               name: 'openai-chat');
           validateTranscription(
               chatResponse.choices.first.message.content.replaceAll('\n', '|'));
         } else {
           log(response.reasonPhrase.toString());
         }
       } on Exception catch (ex) {
         log(ex.toString());
       } finally {
         isLoading.sink.add(false);
       }
     }
   ```

1. Validate if the response has the data that i want:

   ```dart
   bool validateTranscription(String text) {
       if (text.startsWith('Lo siento')) {
         isValidTranscription.sink.add(false);
         transcription.sink.add(
             'Lo siento, tu solicitud no contiene información de origen, ni destino, ni fecha, por favor intenta nuevamente');
         return false;
       }

       try {
         List<String> listString = text.split('|');

         String origin = listString[0].split(':')[1].trim();
         String destination = listString[1].split(':')[1].trim();
         String date = listString[2].split(':')[1].trim();

         log('origin: $origin, destination: $destination, date: $date',
             name: 'isValidSearch');

         if (origin.isNotEmpty && destination.isNotEmpty) {
           isValidTranscription.sink.add(true);
           return true;
         }

         isValidTranscription.sink.add(false);
         return false;
       } on Exception catch (ex) {
         log(ex.toString());
         isValidTranscription.sink.add(false);
         return false;
       }
     }
   ```

### 📚 Resources

---

- [https://openai.com/research/whisper](https://openai.com/research/whisper)
- [https://github.com/openai/whisper#available-models-and-languages](https://github.com/openai/whisper#available-models-and-languages)
- [https://platform.openai.com/docs/api-reference/audio/create](https://platform.openai.com/docs/api-reference/audio/create)
- [https://platform.openai.com/docs/guides/speech-to-text](https://platform.openai.com/docs/guides/speech-to-text)
- [https://platform.openai.com/docs/guides/speech-to-text/prompting](https://platform.openai.com/docs/guides/speech-to-text/prompting)
- [https://platform.openai.com/docs/api-reference/making-requests](https://platform.openai.com/docs/api-reference/making-requests)
- [https://github.com/reservamos/speech-to-text-demo](https://github.com/reservamos/speech-to-text-demo)
