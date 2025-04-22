class Verse {
  String? id;
  int book;
  int chapter;
  int verse;
  String verseText;
  int? higlightColor;
  bool isFavorite;
  String sideNote;
  String bookName;
  Verse({
    this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.verseText,
    required this.bookName,
    this.higlightColor,
    this.isFavorite = false,
    this.sideNote = "",
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'book': book,
      'chapter': chapter,
      'verse': verse,
      'verseText': verseText,
      'higlightColor': higlightColor,
      'isFavorite': isFavorite ? 1 : 0,
      'sideNote': sideNote,
      'bookName': bookName,
    };
  }

  Verse.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      book = map['book'],
      chapter = map['chapter'],
      verse = map['verse'],
      bookName = map['bookName'],
      verseText = map['verseText'],
      higlightColor = map['higlightColor'],
      isFavorite = map['isFavorite'] == 1,
      sideNote = map['sideNote'] ?? "";
}
