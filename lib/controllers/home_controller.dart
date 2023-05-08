import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:rxdart/subjects.dart';
import 'package:sttdemo/utils/constants.dart';

import '../models/models.dart';

class HomeController {
  final Record _record = Record();
  final BehaviorSubject<bool> isLoading = BehaviorSubject<bool>();
  final BehaviorSubject<String> transcription = BehaviorSubject<String>();
  final BehaviorSubject<bool> isValidTranscription = BehaviorSubject<bool>();

  Future<void> startRecord() async {
    Directory tmpDir = await getTemporaryDirectory();
    String audioPath = '${tmpDir.path}/${Constants.audioFile}';
    transcription.sink.add('');
    isValidTranscription.sink.add(false);

    if (await _record.hasPermission()) {
      // Start recording
      await _record.start(
        path: audioPath,
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );
    }
  }

  Future<void> stopRecord() async {
    await _record.stop();
    if (!await _record.isRecording()) {
      getOpenAITranscription();
    }
  }

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
}
