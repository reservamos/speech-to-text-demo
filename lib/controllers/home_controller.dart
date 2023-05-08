import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:sttdemo/utils/constants.dart';

class HomeController {
  HomeController() {
    record = Record();
  }

  late final Record record;

  Future<void> startRecord() async {
    Directory tmpDir = await getTemporaryDirectory();
    String audioPath = '${tmpDir.path}/${Constants.audioFile}';
    log(audioPath);
    if (await record.hasPermission()) {
      // Start recording
      await record.start(
        path: audioPath,
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );
    }
  }

  Future<void> stopRecord() async {
    await record.stop();
    // if (!await record.isRecording()) {
    //   getOpenAITranscription();
    // }
  }

  Future<void> getOpenAITranscription() async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ${const String.fromEnvironment('API_KEY')}'
    };

    MultipartRequest request = MultipartRequest(
      'POST',
      Uri(
        host: const String.fromEnvironment('OPEN_AI_API'),
        path: '/audio/transcriptions',
      ),
    );

    request.fields.addAll({
      'model': Constants.openAIModel,
      'language': Constants.openAIAudioLanguage,
      'prompt': Constants.openAIPropmt
    });

    Directory tmpDir = await getTemporaryDirectory();
    request.files.add(await MultipartFile.fromPath(
      'file',
      tmpDir.path,
      filename: Constants.audioFile,
    ));

    request.headers.addAll(headers);

    StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log(await response.stream.bytesToString());
    } else {
      log(response.reasonPhrase.toString());
    }
  }
}
