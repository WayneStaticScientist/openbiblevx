import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActivitiesCorner extends StatelessWidget {
  const ActivitiesCorner({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Games | Extensions"),
                IconButton(onPressed: () {}, icon: Icon(Icons.add)),
              ],
            ),
            Divider(),
            ListTile(
              title: Text("Bible Trivia"),
              trailing: Icon(Icons.chevron_right),
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(
                  FontAwesomeIcons.question,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
            ListTile(
              title: Text("Lazy Pilot"),
              trailing: Icon(Icons.chevron_right),
              leading: CircleAvatar(
                backgroundColor: Colors.lightBlue,
                child: Icon(
                  FontAwesomeIcons.plane,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
            ElevatedButton(onPressed: () {}, child: Text("download more")),
          ],
        ),
      ),
    );
  }
}
