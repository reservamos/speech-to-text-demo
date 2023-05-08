class TranscriptionResponse {
  String text;

  TranscriptionResponse({
    required this.text,
  });

  factory TranscriptionResponse.fromJson(Map<String, dynamic> json) =>
      TranscriptionResponse(
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
      };

  @override
  String toString() => '{text: $text}';
}
