import 'dart:developer';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:open_bible_ai/bible/bible.dart';
import 'package:open_bible_ai/pages/read_verse_main.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class BooksViewSlider extends StatefulWidget {
  const BooksViewSlider({super.key});

  @override
  State<BooksViewSlider> createState() => _BooksViewSliderState();
}

class _BooksViewSliderState extends State<BooksViewSlider> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(title: Text("Books"), centerTitle: true, floating: true),
        SliverToBoxAdapter(child: Center(child: Text("Holy Bible Books"))),
        SliverList.list(
          children: [
            ...Bible.oldTestament.map<Widget>((e) => _buildBookView(e)),
            ClayContainer(
              color: Get.theme.colorScheme.surface,

              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(FontAwesomeIcons.bookBible, color: Colors.white),
                ),
                trailing: Icon(FontAwesomeIcons.arrowDown, color: Colors.blue),
                title: TextAnimator(
                  "NEW TESTAMENT",
                  atRestEffect: WidgetRestingEffects.wave(),
                ),
              ),
            ),
            ...Bible.newTestament.map<Widget>((e) => _buildBookView(e)),
          ],
        ),
      ],
    );
  }

  Widget _buildBookView(Book e) {
    return InkWell(
      onTap: () => _showModal(e),
      child: Card(
        color: Get.theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(FontAwesomeIcons.list, size: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(e.name, style: TextStyle(fontSize: 12)),
                  ),
                  Icon(FontAwesomeIcons.hashtag, size: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      e.count.toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              Divider(),
              ListTile(
                title: Text(
                  e.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                leading: Text(e.index.toString()),
                trailing: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showModal(Book e) {
    showModalBottomSheet(
      context: context,
      builder:
          (modalContext) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  ListTile(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.of(modalContext).pop();
                        int index = e.index - 1;
                        if (e.index == 0) {
                          index = 66;
                        }
                        _showModal(Bible.mixed[index - 1]);
                      },
                      icon: Icon(FontAwesomeIcons.chevronLeft),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.of(modalContext).pop();
                        int index = e.index + 1;
                        if (e.index == 66) {
                          index = 1;
                        }
                        _showModal(Bible.mixed[index - 1]);
                      },
                      icon: Icon(FontAwesomeIcons.chevronRight),
                    ),
                    title: Text(
                      e.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: e.count,
                      itemBuilder:
                          (context, index) => InkWell(
                            onTap: () {
                              Navigator.of(modalContext).pop();
                              Get.to(
                                () => ReadVerseMain(
                                  selectedBook: SelectedBook(
                                    book: e.index,
                                    chapter: index + 1,
                                  ),
                                ),
                              );
                            },
                            child: Center(child: Text("${index + 1}")),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
