class Methods {
  String name;
  String company;
  String language;

  String bookLabel;
  String bookNameLabel;
  int bookOffSet;
  int verseOffSet;
  int chapterOffset;
  String verseLabel;
  String chapterLabel;
  String verseNumberLabel;
  String chapterNumberLabel;
  String bookNumberLabel;

  Methods({
    required this.name,
    this.bookOffSet = 0,
    this.verseOffSet = 0,
    required this.company,
    this.chapterOffset = 0,
    required this.language,
    required this.bookLabel,
    required this.verseLabel,
    required this.chapterLabel,
    required this.bookNameLabel,
    required this.bookNumberLabel,
    required this.verseNumberLabel,
    required this.chapterNumberLabel,
  });
  factory Methods.defaultBible() {
    return Methods(
      name: "ENGLISHNIB",
      company: 'openchains',
      language: "English",
      bookLabel: "BIBLEBOOK",
      verseLabel: "VERS",
      chapterLabel: "CHAPTER",
      bookNameLabel: "bname",
      bookNumberLabel: "bnumber",
      verseNumberLabel: "vnumber",
      chapterNumberLabel: "cnumber",
    );
  }
}
