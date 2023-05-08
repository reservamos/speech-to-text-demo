import 'message.dart';

class Choice {
  Message message;
  String finishReason;
  int index;

  Choice({
    required this.message,
    required this.finishReason,
    required this.index,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        message: Message.fromJson(json["message"]),
        finishReason: json["finish_reason"],
        index: json["index"],
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "finish_reason": finishReason,
        "index": index,
      };
}
