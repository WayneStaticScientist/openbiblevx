import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_bible_ai/bible/db/bible_verse.dart';

class VerseWidget extends StatelessWidget {
  final Verse verse;
  final bool selected;
  const VerseWidget({super.key, required this.verse, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          selected
              ? Get.theme.colorScheme.primary
              : Get.theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            text: "${verse.verse}",
            style: TextStyle(
              fontSize: 20,
              color: _getColor(),
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(
                text: verse.verseText,
                style: TextStyle(color: _getColor()),
              ),
              verse.sideNote.isNotEmpty
                  ? TextSpan(
                    text: verse.sideNote,
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                  : TextSpan(),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColor() {
    return (selected
        ? Colors.white
        : (verse.higlightColor == null
            ? Get.theme.colorScheme.onSurface
            : Color(verse.higlightColor!)));
  }
}
