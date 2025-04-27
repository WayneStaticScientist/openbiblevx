import 'dart:developer';

import 'package:open_bible_ai/bible/bible.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast_io.dart';
import 'package:open_bible_ai/bible/db/bible_verse.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BibleDbs {
  static Database? _db;
  static int idCount = 0;
  Future<Database> openDb(String name) async {
    if (_db != null) return _db!;
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    BibleDbs._db = await databaseFactoryIo.openDatabase(join(dir.path, name));
    return BibleDbs._db!;
  }

  Future<void> addVerse(
    String dbName,
    String collectionName,
    Verse verse,
  ) async {
    final db = await openDb(dbName);
    verse.id = idCount.toString();
    idCount++;
    final store = intMapStoreFactory.store(collectionName);
    await store.add(db, verse.toMap());
  }

  destroyDb() {
    if (_db != null) {
      _db!.close();
      _db = null;
    }
  }

  static Future<String> getDefaultName(int book) async {
    final pref = await SharedPreferences.getInstance();
    return "${Bible.mixed[book - 1].name}${pref.getString("default") ?? "ENGLISHNIBopenchains"}";
  }

  static String intoChapterColumn(int chapter) {
    return "Chapter_$chapter";
  }

  Future<List<Verse>> getVerses(String dbName, String collectionName) async {
    final db = await openDb(dbName);
    final store = intMapStoreFactory.store(collectionName);
    final finder = Finder();
    final recordSnapshots = await store.find(db, finder: finder);
    return recordSnapshots.map((snapshot) {
      final verse = Verse.fromMap(snapshot.value);
      return verse;
    }).toList();
  }

  Future<List<Verse>> getDefaultVerseById(
    int book,
    int chapter, {
    int startVerse = 1,
    int endVerse = 1000,
  }) async {
    if (book <= 0 || book > Bible.mixed.length) {
      throw Exception("Invalid book number: $book");
    }
    if (chapter <= 0 || chapter > Bible.mixed[book - 1].count) {
      throw Exception("Invalid chapter number: $chapter");
    }
    final db = await openDb(await getDefaultName(book));
    final store = intMapStoreFactory.store(intoChapterColumn(chapter));
    final finder = Finder(
      filter: Filter.and([
        Filter.greaterThanOrEquals('verse', startVerse),
        Filter.lessThanOrEquals('verse', endVerse),
      ]),
    );
    final recordSnapshots = await store.find(db, finder: finder);
    return recordSnapshots
        .map((snapshot) => Verse.fromMap(snapshot.value))
        .toList();
  }

  Future<void> updateVerse(Verse verse) async {
    if (verse.book <= 0 || verse.book > Bible.mixed.length) {
      throw Exception("Invalid book number: ${verse.book}");
    }
    if (verse.chapter <= 0 ||
        verse.chapter > Bible.mixed[verse.book - 1].count) {
      throw Exception("Invalid chapter number: ${verse.chapter}");
    }
    final db = await openDb(await getDefaultName(verse.book));
    final store = intMapStoreFactory.store(intoChapterColumn(verse.chapter));
    final finder = Finder(filter: Filter.equals('verse', verse.verse));
    final recordSnapshots = await store.find(db, finder: finder);
    if (recordSnapshots.isNotEmpty) {
      await store.record(recordSnapshots.first.key).update(db, verse.toMap());
    } else {
      throw Exception("Verse not found");
    }
  }
}
