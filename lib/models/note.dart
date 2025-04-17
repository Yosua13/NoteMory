class Note {
  final String? id;
  final String? userId;
  final String? title;
  final String? content;
  final String? date;
  final String? textLenght;

  Note({
    this.id,
    this.userId,
    this.title,
    this.content,
    this.date,
    this.textLenght,
  });

  /// Konversi Note menjadi Map untuk disimpan di SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'date': date,
      'textLenght': textLenght
    };
  }

  /// Membuat Note dari Map yang diambil dari SharedPreferences
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      content: map['content'],
      date: map['date'],
      textLenght: map['textLenght'],
    );
  }
}
