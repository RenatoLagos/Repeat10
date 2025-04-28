class Phrase {
  final int? id;
  final String text;
  final String type; // 'profile', 'common', 'idiom', 'random'

  Phrase({this.id, required this.text, required this.type});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'type': type,
    };
  }

  factory Phrase.fromMap(Map<String, dynamic> map) {
    return Phrase(
      id: map['id'] as int?,
      text: map['text'] as String,
      type: map['type'] as String,
    );
  }
} 