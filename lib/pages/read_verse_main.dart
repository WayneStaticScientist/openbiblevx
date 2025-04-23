import 'package:get/get.dart';
import 'package:hidable/hidable.dart';
import 'package:flutter/material.dart';
import 'package:open_bible_ai/bible/bible.dart';
import 'package:open_bible_ai/bible/db/bible_verse.dart';
import 'package:open_bible_ai/constants/constants.dart';
import 'package:open_bible_ai/widgets/error_widget.dart';
import 'package:open_bible_ai/widgets/loaders_widget.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_bible_ai/bible/db/bible_db_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                  icon: Icon(FontAwesomeIcons.arrowsUpToLine),
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
              },
            ),
          ),
        ),
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
            return KeyedSubtree(
              key: _itemKeys[index],
              child: InkWell(
                onTap:
                    () => {
                      _showPopup(context, verses[index], _itemKeys[index]),
                    },
                child: Padding(
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
                          style: TextStyle(
                            color: Get.theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
    PopupMenu menu = PopupMenu(
      context: context,
      config: MenuConfig(
        backgroundColor: Get.theme.colorScheme.primary,
        lineColor: Get.theme.colorScheme.onPrimary,
        highlightColor: Get.theme.colorScheme.primary,
      ),
      items: [
        PopUpMenuItem(
          title: 'highlight',
          image: FaIcon(FontAwesomeIcons.highlighter, color: Colors.white),
        ),
        PopUpMenuItem(
          title: 'Copy',
          image: FaIcon(FontAwesomeIcons.copy, color: Colors.white),
        ),
        PopUpMenuItem(
          title: 'note',
          image: FaIcon(FontAwesomeIcons.noteSticky, color: Colors.white),
        ),
        PopUpMenuItem(
          title: 'translate',
          image: FaIcon(FontAwesomeIcons.language, color: Colors.white),
        ),
        PopUpMenuItem(
          title: 'like',
          image: FaIcon(FontAwesomeIcons.heart, color: Colors.white),
        ),
        PopUpMenuItem(
          title: 'select',
          image: FaIcon(FontAwesomeIcons.check, color: Colors.white),
        ),
      ],
      onClickMenu: (e) => {},
    );
    menu.show(widgetKey: key);
  }
}
