import 'dart:io';
import 'dart:convert';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:open_bible_ai/bible/installer/bible_meta_data.dart';
import 'package:open_bible_ai/bible/installer/progress_stream.dart';
import 'package:open_bible_ai/constants/constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

class BibleExtensionInstaller {
  static Database? _extensionDb;
  int currentStage = 0;
  int totalStage = 0;
  static Future<File> loadImageFromExtensionsDirectory(
    String package,
    String fileName,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$package/$fileName';
    final f = File(filePath);
    if (!(await f.exists())) throw Exception("file doesnt exists");
    return f;
  }

  Future<void> installExtension(
    File opbf,
    Function(ProgressStream stream) streamUpdate,
  ) async {
    currentStage = 1;
    totalStage = 5;
    final destinationDir = await Directory.systemTemp.createTemp(
      'bible_extension_',
    );
    await ZipFile.extractToDirectory(
      zipFile: opbf,
      destinationDir: destinationDir,
      onExtracting: (zipEntry, progress) {
        streamUpdate(
          ProgressStream(
            currentStage: currentStage,
            totalStages: totalStage,
            progress: progress.toInt(),
            message: 'Extracting: ${zipEntry.name}',
          ),
        );
        return ZipFileOperation.includeItem;
      },
    );
    final manifestFile = File('${destinationDir.path}/open.mf');
    if (!(await manifestFile.exists())) {
      throw Exception("metadata file missing | extension installing stopped");
    }
    streamUpdate(
      ProgressStream(
        currentStage: ++currentStage,
        totalStages: totalStage,
        progress: 20,
        message: 'Fetching meta data info',
      ),
    );
    final manifestJson = jsonDecode(await manifestFile.readAsString());
    streamUpdate(
      ProgressStream(
        currentStage: currentStage,
        totalStages: totalStage,
        progress: 100,
        message: 'Reading metadata',
      ),
    );
    final metaData = BibleMetaData.fromMap(manifestJson);
    if (metaData.extensionName.isEmpty) {
      throw Exception("invalid extension name");
    }
    if (metaData.extensionType.isEmpty) {
      throw Exception("invalid extension type");
    }
    if (metaData.indexName.isEmpty) {
      throw Exception("invalid index name");
    }
    if (metaData.package.isEmpty) {
      throw Exception("invalid package name");
    }

    final indexFile = File('${destinationDir.path}/${metaData.indexName}');
    if (!(await indexFile.exists())) {
      throw Exception("index file missing");
    }
    final iconFile = File('${destinationDir.path}/${metaData.extensionIcon}');
    if (!(await iconFile.exists())) {
      metaData.hasIcon = false;
    }
    if (!AppConstants.BibleExtensionSupportedTypes.contains(
      metaData.extensionType.toLowerCase(),
    )) {
      throw Exception("invalid extension operation");
    }
    if (!AppConstants.BibleIndexSupportedTypes.contains(
      metaData.indexType.toLowerCase(),
    )) {
      throw Exception("invalid index operation");
    }
    final dir = await getApplicationDocumentsDirectory();
    final permanentDir = Directory(
      join(dir.path, "extensions", metaData.package),
    );
    if (!await permanentDir.exists()) {
      await permanentDir.create(recursive: true);
    }
    currentStage++;
    int i = 0;
    streamUpdate(
      ProgressStream(
        currentStage: currentStage,
        totalStages: totalStage,
        progress: 0,
        message: 'Copying files',
      ),
    );
    await for (final entity in destinationDir.list(recursive: true)) {
      final relativePath = entity.path.replaceFirst(destinationDir.path, '');
      final newPath = permanentDir.path + relativePath;
      if (entity is File) {
        final newFile = File(newPath);
        if (!await newFile.parent.exists()) {
          await newFile.parent.create(recursive: true);
        }
        await entity.copy(newFile.path);
      } else if (entity is Directory) {
        final newDir = Directory(newPath);
        if (!await newDir.exists()) {
          await newDir.create(recursive: true);
        }
      }
      streamUpdate(
        ProgressStream(
          currentStage: currentStage,
          totalStages: totalStage,
          progress: (++i),
          message: 'Copying files',
        ),
      );
    }
    await destinationDir.delete(recursive: true);
    streamUpdate(
      ProgressStream(
        currentStage: ++currentStage,
        totalStages: totalStage,
        progress: 100,
        message: 'Creating database',
      ),
    );
    await addExtensionToDb(metaData);
    streamUpdate(
      ProgressStream(
        currentStage: ++currentStage,
        totalStages: totalStage,
        finishedStream: true,
        progress: 100,
        message: 'Extension ${metaData.extensionName} installed succesffully',
      ),
    );
  }

  Future<Database> openDb() async {
    if (_extensionDb != null) return _extensionDb!;
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    _extensionDb = await databaseFactoryIo.openDatabase(
      join(dir.path, "extensions.db"),
    );
    return _extensionDb!;
  }

  Future<void> addExtensionToDb(BibleMetaData metadata) async {
    final db = await openDb();
    final store = intMapStoreFactory.store(metadata.extensionType);
    await store.add(db, metadata.toMap());
  }

  Future<List<BibleMetaData>> getExtensionsList() async {
    final db = await openDb();
    final store = intMapStoreFactory.store(
      AppConstants.BibleExtensionSupportedTypes[0],
    );
    final finder = Finder();
    final recordSnapshots = await store.find(db, finder: finder);
    final List<BibleMetaData> extensions = [];
    for (var record in recordSnapshots) {
      final metadata = BibleMetaData.fromMap(record.value);
      extensions.add(metadata);
    }
    return extensions;
  }
}
