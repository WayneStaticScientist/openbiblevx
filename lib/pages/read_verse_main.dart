import 'package:get/get.dart';
import 'package:hidable/hidable.dart';
import 'package:flutter/material.dart';
import 'package:open_bible_ai/bible/bible.dart';
import 'package:open_bible_ai/constants/constants.dart';
import 'package:open_bible_ai/bible/db/bible_verse.dart';
import 'package:open_bible_ai/widgets/error_widget.dart';
import 'package:open_bible_ai/widgets/loaders_widget.dart';
import 'package:open_bible_ai/widgets/verse_displays.dart';
import 'package:open_bible_ai/utils/verse_operations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_bible_ai/bible/db/bible_db_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_bible_ai/utils/notifications_operations.dart';

class ReadVerseMain extends StatefulWidget {
  final SelectedBook selectedBook;
  const ReadVerseMain({super.key, required this.selectedBook});
  @override
  State<ReadVerseMain> createState() => _ReadVerseMainState();
}

class _ReadVerseMainState extends State<ReadVerseMain> {
  late Future<List<Verse>> _loadVerses;
  final List<Verse> _selectedVerses = [];
  bool _autoScroll = false;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _loadVerses = _getVerses(widget.selectedBook);
  }

  @override
  void dispose() {
    _addToStorage();
    _scrollController.dispose();
    super.dispose();
  }

  _addToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(AppConstants.LCHAPTER, widget.selectedBook.chapter);
    prefs.setInt(AppConstants.LBOOK, widget.selectedBook.book);
    prefs.setInt(AppConstants.LVERSE, 1);
    prefs.setInt(AppConstants.LDATE, DateTime.now().millisecondsSinceEpoch);
    prefs.setString(
      AppConstants.LVERSETEXT,
      _globalVerses.isNotEmpty
          ? _globalVerses[0].verseText
          : "The book didnt load verses",
    );
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
      bottomNavigationBar: Container(
        color: Get.theme.colorScheme.surface,
        child: SafeArea(
          child: Hidable(
            controller: _scrollController,
            deltaFactor: 0.1,
            child: BottomNavigationBar(
              backgroundColor: Get.theme.colorScheme.surface,
              unselectedItemColor: Get.theme.colorScheme.onSurface,
              selectedItemColor: Get.theme.colorScheme.onSurface,
              showSelectedLabels: false,
              type: BottomNavigationBarType.shifting,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.chevronLeft),
                  label: "left",
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.earthAfrica),
                  label: "language",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.arrowsUpToLine,
                    color: _autoScroll ? Get.theme.colorScheme.primary : null,
                  ),
                  label: "auto scroll",
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.speakap),
                  label: "Favorites",
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.chevronRight),
                  label: "Read",
                ),
              ],
              currentIndex: 1,
              onTap: (index) {
                if (index == 0) {
                  _prevPage();
                }
                if (index == 3) {
                  _nextPage();
                }
                if (index == 2) {
                  _activateAutoScroll();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Verse>> _getVerses(SelectedBook book) async {
    final db = BibleDbs();
    final results = await db.getVerses(
      await BibleDbs.getDefaultName(book.book),
      BibleDbs.intoChapterColumn(book.chapter),
    );
    db.destroyDb();
    _globalVerses = results;
    _itemKeys = List.generate(results.length, (_) => GlobalKey());
    return results;
  }

  List<Verse> _globalVerses = [];
  List<GlobalKey> _itemKeys = [];
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
              icon: Icon(FontAwesomeIcons.tableColumns),
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
            final selected = _selectedVerses.contains(verses[index]);
            return KeyedSubtree(
              key: _itemKeys[index],
              child: InkWell(
                onTap: () {
                  if (_selectedVerses.isNotEmpty) {
                    _addToSelection(verses[index]);
                  } else {
                    _showPopup(context, verses[index], _itemKeys[index]);
                  }
                },
                child: VerseWidget(verse: verses[index], selected: selected),
              ),
            );
          },
          itemCount: verses.length + 1,
        ),
      ],
    );
  }

  _nextPage() {
    if (widget.selectedBook.chapter <
        Bible.mixed[widget.selectedBook.book - 1].count) {
      widget.selectedBook.chapter++;
      _refreshPage();
    } else {
      if (widget.selectedBook.book < 66) {
        widget.selectedBook.book++;
        widget.selectedBook.chapter = 1;
        _refreshPage();
      } else {
        widget.selectedBook.book = 1;
        widget.selectedBook.chapter = 1;
        _refreshPage();
      }
    }
  }

  _prevPage() {
    if (widget.selectedBook.chapter > 1) {
      widget.selectedBook.chapter--;
      _refreshPage();
    } else {
      if (widget.selectedBook.book > 1) {
        widget.selectedBook.book--;
        widget.selectedBook.chapter =
            Bible.mixed[widget.selectedBook.book - 1].count;
        _refreshPage();
      } else {
        widget.selectedBook.book = 66;
        widget.selectedBook.chapter =
            Bible.mixed[widget.selectedBook.book - 1].count;
        _refreshPage();
      }
    }
  }

  _refreshPage() {
    setState(() {
      _loadVerses = _getVerses(widget.selectedBook);
    });
  }

  _showPopup(BuildContext context, Verse verse, GlobalKey key) {
    NotificationsOperations.showVersesPopupDialog(
      context,
      verse,
      key: key,
      copyAction: (verse) async {
        await VerseOperations.copyVerse(verse);
        if (mounted) {
          NotificationsOperations.showNotification("Verse copied");
        }
      },
      highlightAction: _voidShowHighLightDialog,
      noteAction: (verse) => _showNoteEditor(verse),
      selectedAction: (verse) => _addToSelection(verse),
    );
  }

  void _voidShowHighLightDialog(List<Verse> verses) async {
    final respone = await VerseOperations.highLightVerse(context, verses);
    if (respone == true) {
      NotificationsOperations.showNotification("Verse highlighted");
      _refreshPage();
    }
  }

  _activateAutoScroll() async {
    setState(() {
      _autoScroll = !_autoScroll;
    });
    while (_autoScroll) {
      if (!_autoScroll) return false;
      await _scrollController.animateTo(
        _scrollController.position.pixels + 50,
        duration: Duration(milliseconds: 1000),
        curve: Curves.linear,
      );
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  _showNoteEditor(Verse verse) async {
    final response = await NotificationsOperations.editVerseNote(
      context,
      verse,
    );
    if (response == true) {
      NotificationsOperations.showNotification("Note updated");
      _refreshPage();
    }
  }

  _addToSelection(Verse verse) {
    setState(() {
      if (_selectedVerses.contains(verse)) {
        _selectedVerses.remove(verse);
      } else {
        _selectedVerses.add(verse);
      }
    });
  }
}
