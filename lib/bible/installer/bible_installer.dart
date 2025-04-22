import 'package:open_bible_ai/bible/bible.dart';
import 'package:open_bible_ai/bible/db/bible_db_helper.dart';
import 'package:open_bible_ai/bible/db/bible_verse.dart';
import 'package:open_bible_ai/bible/installer/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

class BibleInstaller {
  static int counter = 0;
  final bibleDb = BibleDbs();
  Stream<int> installBook(XmlDocument document, Methods metadata) async* {
    counter = 1;
    final elements = document.findAllElements(metadata.bookLabel);
    for (var element in elements) {
      yield await addBook(
        int.tryParse(element.getAttribute(metadata.bookNumberLabel) ?? "-") ??
            0 + metadata.bookOffSet,
        element,
        metadata,
      );
      bibleDb.destroyDb();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("loaded", true);
    yield 200;
  }

  Future<int> addBook(
    int bookNumber,
    XmlElement element,
    Methods metadata,
  ) async {
    var elements = element.findAllElements(metadata.chapterLabel);
    final bookLabel =
        Bible.mixed[bookNumber - 1].name + metadata.name + metadata.company;
    for (var chapter in elements) {
      await addChapter(
        bookNumber,
        bookLabel,
        chapter,
        metadata,
        element.getAttribute(metadata.bookNameLabel) ??
            Bible.mixed[bookNumber - 1].name,
      );
    }
    return (counter++);
  }

  Future<void> addChapter(
    int bookNumber,
    String book,
    XmlElement element,
    Methods metadata,
    String bookName,
  ) async {
    int chapterNumber =
        int.tryParse(
          element.getAttribute(metadata.chapterNumberLabel) ?? "-",
        ) ??
        0;
    final verses = element.findAllElements(metadata.verseLabel);
    for (var verse in verses) {
      await bibleDb.addVerse(
        book,
        "Chapter_${chapterNumber + metadata.chapterOffset}",
        Verse(
          book: bookNumber,
          chapter: chapterNumber,
          bookName: bookName,
          verse:
              int.tryParse(
                verse.getAttribute(metadata.verseNumberLabel) ?? '-',
              ) ??
              0,
          verseText: verse.innerText,
        ),
      );
    }
  }
}
