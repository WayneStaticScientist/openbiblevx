import 'package:path/path.dart';
import 'package:sembast/sembast_io.dart';
import 'package:open_bible_ai/bible/db/bible_verse.dart';
import 'package:path_provider/path_provider.dart';

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

  static String getDefaultName(int book) {
    return "ENGLISHNIBopenchains";
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
}
