class Transcription {
  String text;

  Transcription({
    required this.text,
  });

  factory Transcription.fromJson(Map<String, dynamic> json) => Transcription(
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
      };

  @override
  String toString() => '{text: $text}';
}
