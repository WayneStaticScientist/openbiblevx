import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_bible_ai/bible/db/bible_db_helper.dart';
import 'package:open_bible_ai/bible/db/bible_verse.dart';
import 'package:open_bible_ai/constants/widget_constants.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';

class NotificationsOperations {
  static void showNotification(String body) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(body), duration: const Duration(seconds: 2)),
    );
  }

  static void showVersesPopupDialog(
    BuildContext context,
    Verse verse, {
    required GlobalKey key,
    Function(List<Verse> verse)? highlightAction,
    Function(Verse verse)? copyAction,
    Function(Verse verse)? noteAction,
    Function(Verse verse)? selectedAction,
  }) {
    PopupMenu menu = PopupMenu(
      context: context,
      config: MenuConfig(
        backgroundColor: Get.theme.colorScheme.primary,
        lineColor: Get.theme.colorScheme.onPrimary,
        highlightColor: Get.theme.colorScheme.primary,
      ),
      items: WidgetConstants.getVersePopupItems(),
      onClickMenu: (e) async {
        if (e.menuTitle.toLowerCase() == "highlight") {
          if (highlightAction != null) highlightAction([verse]);
        }
        if (e.menuTitle.toLowerCase() == "copy") {
          if (copyAction != null) {
            copyAction(verse);
          }
        }
        if (e.menuTitle.toLowerCase() == "note") {
          if (noteAction != null) {
            noteAction(verse);
          }
        }
        if (e.menuTitle.toLowerCase() == "select") {
          if (selectedAction != null) {
            selectedAction(verse);
          }
        }
      },
    );
    menu.show(widgetKey: key);
  }

  static Future<bool?> editVerseNote(BuildContext context, Verse verse) async {
    final noteController = TextEditingController(text: verse.sideNote);
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Note"),
          content: TextField(
            controller: noteController,
            decoration: InputDecoration(hintText: "Enter your note here"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Update with the new note
                final bibleDb = BibleDbs();
                verse.sideNote = noteController.text;
                await bibleDb.updateVerse(verse);
                if (context.mounted) {
                  Navigator.of(context).pop(true);
                }
              },
              child: Text("update"),
            ),
          ],
        );
      },
    );
  }
}
