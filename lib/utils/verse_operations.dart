import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:open_bible_ai/bible/bible.dart';
import 'package:open_bible_ai/bible/db/bible_db_helper.dart';
import 'package:open_bible_ai/bible/db/bible_verse.dart';

class VerseOperations {
  static Future<void> copyVerse(Verse verse) async {
    await FlutterClipboard.copy(
      '${Bible.mixed[verse.book - 1].name} ${verse.chapter}\n${verse.verse})${verse.verseText}',
    );
  }

  static Future<bool?> highLightVerse(
    BuildContext context,
    List<Verse> verses,
  ) async {
    Color? selectedColor;
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Highlight Color"),
          content: ColorPicker(
            pickerColor: selectedColor ?? Get.theme.colorScheme.primary,
            onColorChanged: (color) {
              selectedColor = color;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (selectedColor != null) {
                  await _changeVerseColor(selectedColor!, verses);
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                }
              },
              child: Text("update"),
            ),
          ],
        );
      },
    );
  }

  static _changeVerseColor(Color selectedColor, List<Verse> verses) async {
    final bibleDb = BibleDbs();
    for (final verse in verses) {
      verse.higlightColor = selectedColor.toARGB32();
      await bibleDb.updateVerse(verse);
    }
    bibleDb.destroyDb();
  }
}
