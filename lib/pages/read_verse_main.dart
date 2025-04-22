import 'dart:developer';

import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hidable/hidable.dart';
import 'package:open_bible_ai/bible/bible.dart';
import 'package:open_bible_ai/bible/db/bible_db_helper.dart';
import 'package:open_bible_ai/bible/db/bible_verse.dart';
import 'package:open_bible_ai/widgets/error_widget.dart';
import 'package:open_bible_ai/widgets/loaders_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class ReadVerseMain extends StatefulWidget {
  final SelectedBook selectedBook;
  const ReadVerseMain({super.key, required this.selectedBook});
  @override
  State<ReadVerseMain> createState() => _ReadVerseMainState();
}

class _ReadVerseMainState extends State<ReadVerseMain> {
  late Future<List<Verse>> _loadVerses;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _loadVerses = _getVerses(widget.selectedBook);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: FutureBuilder(
        future: _loadVerses,
        builder: (context, snapshot) {
          if (snapshot.hasData) return _buildPage(snapshot.data!);
          if (snapshot.hasError) {
            return NormalError(errorText: "${snapshot.error}");
          }
          return NormalLoader();
        },
      ),
      bottomNavigationBar: DotCurvedBottomNav(
        scrollController: _scrollController,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        hideOnScroll: true,
        indicatorColor: Get.theme.colorScheme.primary,
        backgroundColor: Get.theme.colorScheme.onSurface,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.ease,
        selectedIndex: 2,
        indicatorSize: 5,
        borderRadius: 25,
        onTap: (index) {
          setState(() => {});
        },
        items: [
          Icon(Icons.home, color: Get.theme.colorScheme.surface),
          Icon(Icons.notification_add, color: Get.theme.colorScheme.surface),
          Icon(Icons.color_lens, color: Get.theme.colorScheme.surface),
          Icon(Icons.person, color: Get.theme.colorScheme.surface),
        ],
      ),
    );
  }

  Future<List<Verse>> _getVerses(SelectedBook book) async {
    final db = BibleDbs();
    final pref = await SharedPreferences.getInstance();
    final results = await db.getVerses(
      Bible.mixed[widget.selectedBook.book - 1].name +
          (pref.getString("selected_book") ??
              BibleDbs.getDefaultName(book.book)),
      BibleDbs.intoChapterColumn(book.chapter),
    );
    db.destroyDb();
    return results;
  }

  Widget _buildPage(List<Verse> verses) {
    if (verses.isNotEmpty) {
      widget.selectedBook.bookName = verses[0].bookName;
    }
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          floating: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(FontAwesomeIcons.chevronLeft),
          ),
          actions: [
            IconButton(onPressed: () => {}, icon: Icon(FontAwesomeIcons.heart)),
            IconButton(
              onPressed: () => {},
              icon: Icon(FontAwesomeIcons.noteSticky),
            ),
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(FontAwesomeIcons.ellipsis),
            ),
          ],
          title: Text(
            "${widget.selectedBook.bookName} Chapter ${widget.selectedBook.chapter}",
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${widget.selectedBook.bookName} Chapter ${widget.selectedBook.chapter}",
              style: TextStyle(
                fontSize: 30,
                color: Get.theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverList.builder(
          itemBuilder: (context, index) {
            if (index == verses.length) {
              return SizedBox(height: 150);
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  text: "${verses[index].verse}",
                  style: TextStyle(
                    fontSize: 20,
                    color: Get.theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: verses[index].verseText,
                      style: TextStyle(color: Get.theme.colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: verses.length + 1,
        ),
      ],
    );
  }
}
