import 'package:flutter/material.dart';
import 'package:open_bible_ai/bible/db/bible_verse.dart';
import 'package:open_bible_ai/widgets/verse_displays.dart';

class VerseListView extends StatelessWidget {
  final bool isSplitView;
  final List<Verse> verses;
  final List<Verse> selectedVerses;
  final List<GlobalKey> itemKeys;
  final Function(Verse verse) addToSelection;
  final Function(BuildContext context, Verse verse, GlobalKey key) showPopup;
  const VerseListView({
    super.key,
    required this.isSplitView,
    required this.verses,
    required this.selectedVerses,
    required this.itemKeys,
    required this.addToSelection,
    required this.showPopup,
  });

  @override
  Widget build(BuildContext context) {
    return _getVersesDisplay(verses);
  }

  _getVersesDisplay(List<Verse> verses) {
    return isSplitView ? _getSplitView(verses) : _getListView(verses);
  }

  _getListView(List<Verse> verses) {
    return SliverList.builder(
      itemBuilder: (context, index) {
        if (index == verses.length) {
          return SizedBox(height: 150);
        }
        final selected = selectedVerses.contains(verses[index]);
        return KeyedSubtree(
          key: itemKeys[index],
          child: InkWell(
            onTap: () {
              if (selectedVerses.isNotEmpty) {
                addToSelection(verses[index]);
              } else {
                showPopup(context, verses[index], itemKeys[index]);
              }
            },
            child: VerseWidget(verse: verses[index], selected: selected),
          ),
        );
      },
      itemCount: verses.length + 1,
    );
  }

  _getSplitView(List<Verse> verses) {
    return SliverFillRemaining(
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: verses.length,
              itemBuilder: (context, index) {
                return KeyedSubtree(
                  key: itemKeys[index],
                  child: InkWell(
                    onTap: () {
                      if (selectedVerses.isNotEmpty) {
                        addToSelection(verses[index]);
                      } else {
                        showPopup(context, verses[index], itemKeys[index]);
                      }
                    },
                    child: VerseWidget(verse: verses[index], selected: false),
                  ),
                );
              },
            ),
          ),
          VerticalDivider(),
          Expanded(
            child: ListView.builder(
              itemCount: verses.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: VerseWidget(verse: verses[index], selected: false),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
