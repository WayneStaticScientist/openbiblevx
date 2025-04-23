import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_bible_ai/bible/bible.dart';
import 'package:open_bible_ai/widgets/title_texts.dart';

class AppBookSearchDelegate extends SearchDelegate<Book> {
  final void Function(Book e) showModal;
  AppBookSearchDelegate(this.showModal);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView(
      children:
          Bible.mixed
              .where(
                (book) => book.name.toLowerCase().contains(query.toLowerCase()),
              )
              .map((book) => _buildListTile(book))
              .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children:
          Bible.mixed
              .where(
                (book) => book.name.toLowerCase().contains(query.toLowerCase()),
              )
              .map((book) => _buildListTile(book))
              .toList(),
    );
  }

  Widget _buildListTile(Book e) {
    return ListTile(
      title: BigText(text: e.name),
      leading: CircleAvatar(
        backgroundColor: Color.fromARGB(
          255,
          (e.index * 255) ~/ 66,
          200,
          (e.index * 255) ~/ 66,
        ),
      ),
      subtitle: Text("${e.count} chapters"),
      trailing: Icon(FontAwesomeIcons.chevronRight),
      onTap: () {
        // Handle book selection
        showModal(e);
      },
    );
  }
}
