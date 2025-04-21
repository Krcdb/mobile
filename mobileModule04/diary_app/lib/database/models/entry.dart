class Entry {
  final int? id;
  final int userId;
  final String date;
  final String title;
  final String feeling;
  final String content;

  Entry({
    this.id,
    required this.userId,
    required this.date,
    required this.title,
    required this.feeling,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'date': date,
      'title': title,
      'feeling': feeling,
      'content': content,
    };
  }

  factory Entry.fromMap(Map<String, dynamic> map) {
    return Entry(
      id: map['id'],
      userId: map['user_id'],
      date: map['date'],
      title: map['title'],
      feeling: map['feeling'],
      content: map['content'],
    );
  }
}
