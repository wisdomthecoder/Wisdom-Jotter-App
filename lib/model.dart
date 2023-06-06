
class Note {
  String text;
  DateTime date;
  String title;

  Note({
    required this.text,
    required this.date,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'date': date.toIso8601String(),
      'title': title,
    };
  }

  static Note fromJson(Map<String, dynamic> json) {
    return Note(
      text: json['text'],
      date: DateTime.parse(json['date']),
      title: json['title'],
    );
  }
}
