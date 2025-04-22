import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LastVerse extends StatelessWidget {
  const LastVerse({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Get.theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Last Verse"), Text("Last Date")],
            ),
            Divider(),
            SizedBox(height: 10),
            Text("Verse Content"),
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
