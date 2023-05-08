import 'usage.dart';
import 'choice.dart';

class ChatResponse {
  String id;
  String object;
  int created;
  String model;
  Usage usage;
  List<Choice> choices;

  ChatResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.usage,
    required this.choices,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
        id: json["id"],
        object: json["object"],
        created: json["created"],
        model: json["model"],
        usage: Usage.fromJson(json["usage"]),
        choices:
            List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "created": created,
        "model": model,
        "usage": usage.toJson(),
        "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
      };
}
