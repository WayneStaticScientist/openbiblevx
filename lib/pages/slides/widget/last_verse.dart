import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:open_bible_ai/bible/bible.dart';
import 'package:open_bible_ai/constants/constants.dart';
import 'package:open_bible_ai/widgets/error_widget.dart';
import 'package:open_bible_ai/widgets/loaders_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastVerseStructure {
  int date;
  String verse;
  int bookIndex = 0;
  int chapterIndex = 0;
  int lastVerseNumber = 0;
  LastVerseStructure({
    required this.verse,
    required this.date,
    required this.bookIndex,
    required this.chapterIndex,
    required this.lastVerseNumber,
  });
}

class LastVerse extends StatelessWidget {
  const LastVerse({super.key});
  Future<LastVerseStructure> _loadLastVerse() async {
    final pref = await SharedPreferences.getInstance();
    final lastVerse =
        pref.getString(AppConstants.LVERSETEXT) ??
        "In the beginning God created the heavens and the earth.";
    final lastDate =
        pref.getInt(AppConstants.LDATE) ??
        DateTime.now().millisecondsSinceEpoch;
    final bookIndex = pref.getInt(AppConstants.LBOOK) ?? 1;
    final chapterIndex = pref.getInt(AppConstants.LCHAPTER) ?? 1;
    return LastVerseStructure(
      verse: lastVerse,
      date: lastDate,
      bookIndex: bookIndex,
      chapterIndex: chapterIndex,
      lastVerseNumber: pref.getInt(AppConstants.LVERSE) ?? 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadLastVerse(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const NormalLoader();
        } else if (asyncSnapshot.hasError) {
          return NormalError(
            errorText: "Error loading last verse ${asyncSnapshot.error}",
          );
        } else if (!asyncSnapshot.hasData) {
          return const Center(child: Text("No data found"));
        }
        final lastVerse = asyncSnapshot.data!;
        return _makeWidget(lastVerse);
      },
    );
  }

  Widget _makeWidget(LastVerseStructure lastVerse) {
    return Card(
      color: Get.theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${Bible.mixed[lastVerse.bookIndex - 1].name} ${lastVerse.chapterIndex}",
                ),
                Text(AppConstants.getDate(lastVerse.date)),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Text("${lastVerse.lastVerseNumber}) ${lastVerse.verse}"),
            Divider(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(FontAwesomeIcons.shareNodes),
                ),
                IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.copy)),
                IconButton(
                  onPressed: () {},
                  icon: Icon(FontAwesomeIcons.thumbsUp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
