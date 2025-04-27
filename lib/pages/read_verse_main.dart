import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:open_bible_ai/bible/bible.dart';
import 'package:open_bible_ai/constants/constants.dart';
import 'package:open_bible_ai/bible/db/bible_verse.dart';
import 'package:open_bible_ai/widgets/bottom_nav_main.dart';
import 'package:open_bible_ai/widgets/error_widget.dart';
import 'package:open_bible_ai/widgets/loaders_widget.dart';
import 'package:open_bible_ai/utils/verse_operations.dart';
import 'package:open_bible_ai/widgets/verse_list_view.dart';
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
  bool _isSplitView = false;
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
      bottomNavigationBar: BottomNavMain(
        prevPage: _prevPage,
        nextPage: _nextPage,
        autoScroll: _autoScroll,
        scrollController: _scrollController,
        activateAutoScroll: _activateAutoScroll,
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
            _selectedVerses.isNotEmpty
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedVerses.clear();
                    });
                  },
                  icon: Icon(FontAwesomeIcons.xmark),
                )
                : IconButton(
                  onPressed: () => {},
                  icon: Icon(FontAwesomeIcons.heart),
                ),
            _selectedVerses.isNotEmpty
                ? IconButton(
                  onPressed: () {
                    _voidShowHighLightDialog(_selectedVerses);
                  },
                  icon: Icon(FontAwesomeIcons.highlighter),
                )
                : IconButton(
                  onPressed:
                      () => setState(() {
                        _isSplitView = !_isSplitView;
                      }),
                  icon: Icon(
                    FontAwesomeIcons.tableColumns,
                    color: _isSplitView ? Get.theme.colorScheme.primary : null,
                  ),
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
        VerseListView(
          isSplitView: _isSplitView,
          verses: verses,
          selectedVerses: _selectedVerses,
          itemKeys: _itemKeys,
          addToSelection: _addToSelection,
          showPopup: _showPopup,
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
      _selectedVerses.clear();
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
