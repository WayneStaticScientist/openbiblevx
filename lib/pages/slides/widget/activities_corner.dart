import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_bible_ai/pages/ext_installer_process.dart';
import 'package:open_bible_ai/pages/extensions_list.dart';
import 'package:open_bible_ai/widgets/designer_buttons.dart';
import 'package:open_bible_ai/widgets/title_texts.dart';

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
                IconButton(
                  onPressed: () => _downloadMore(context),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NormalDesignerButton(
                  text: "Install Extension",
                  tap: () {
                    Get.to(() => ExtInstallerProcess());
                  },
                ),
                SizedBox(width: 12),
                NormalDesignerButton(
                  text: "View Extensions",
                  tap: () {
                    Get.to(() => ExtensionsList());
                  },
                ),
              ],
            ),
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
          ],
        ),
      ),
    );
  }

  void _downloadMore(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                BigText(text: "Download Options"),
                ListTile(
                  title: BigText(text: "Install Offline"),
                  subtitle: Text("install .opbf files offline"),
                  onTap: () {
                    Get.to(() => ExtInstallerProcess());
                  },
                  trailing: Icon(Icons.chevron_right),
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: FaIcon(
                      FontAwesomeIcons.sdCard,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  title: BigText(text: "Online store"),
                  subtitle: Text("check out marketplace for extensions"),
                  trailing: Icon(Icons.chevron_right),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: FaIcon(
                      FontAwesomeIcons.networkWired,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Add your download options here
              ],
            ),
          ),
        );
      },
    );
  }
}
