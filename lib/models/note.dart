class Note {
  final String? id;
  final String? title;
  final String? content;
  final String? date;

  Note({
    this.id,
    this.title,
    this.content,
    this.date,
  });

  /// Konversi Note menjadi Map untuk disimpan di SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
    };
  }

  /// Membuat Note dari Map yang diambil dari SharedPreferences
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: map['date'],
    );
  }
}
