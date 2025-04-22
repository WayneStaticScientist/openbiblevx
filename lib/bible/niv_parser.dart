import 'package:xml/xml.dart';

class NivParser {
  static Chapter startParser(XmlDocument document, int book, int page) {
    var elements = document.findAllElements("BIBLEBOOK"); //bnumber the name
    //bool bookFound = true;
    for (var element in elements) {
      var attributes = element.attributes;
      for (var attribute in attributes) {
        if (attribute.name.toString().contains("bnumber")) {
          if (attribute.value.contains("$book")) {
            return dealWithBook(element, page);
          }
        }
      }
    }
    return Chapter(verse: [], chapter: page);
  }

  static Chapter dealWithBook(XmlElement element, int chapter) {
    var elements = element.findAllElements("CHAPTER");
    for (var element in elements) {
      var attributes = element.attributes;
      for (var attribute in attributes) {
        if (attribute.name.toString().contains("cnumber")) {
          if (attribute.value.contains("$chapter")) {
            var chapterList = element.findAllElements("VERS");
            List<Verse> verses = [];
            int i = 0;
            for (var vers in chapterList) {
              i++;
              String? verseNumber = vers.getAttribute("vnumber") ?? "$i";
              String body = vers.text;
              verses.add(Verse(verse: verseNumber, writtable: body));
            }
            return Chapter(verse: verses, chapter: chapter);
          }
        }
      }
    }
    return Chapter(verse: [], chapter: chapter);
  }
}

class Chapter {
  final List<Verse> verse;
  final int chapter;
  Chapter({required this.verse, required this.chapter});
}

class Verse {
  final String verse;
  final String writtable;
  Verse({required this.verse, required this.writtable});
}
