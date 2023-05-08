class Constants {
  static const String audioFile = 'audioFile.m4a';

  static const String openAIHost = 'api.openai.com';
  static const String openAITranscriptionModel = 'whisper-1';
  static const String openAITranscriptionEndpoint = 'v1/audio/transcriptions';
  static const String openAIChatModel = 'gpt-3.5-turbo';
  static const String openAIChatEndpoint = 'v1/chat/completions';
  static const String openAIAudioLanguage = 'es';
  static const String openAIPropmt =
      'el audio es referente a la busqueda de un viaje, en la cual puedes extraer el origen, destino y fecha';
  static String openAIChatPropmt(String text) =>
      'puedes extraer el origen, el destino y fecha de la siguiente cadena de texto: $text';
}
