import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:open_bible_ai/bible/installer/bible_meta_data.dart';
import 'package:open_bible_ai/bible/installer/extension_installer.dart';
import 'package:open_bible_ai/pages/extensions_player.dart';
import 'package:open_bible_ai/widgets/error_widget.dart';
import 'package:open_bible_ai/widgets/loaders_widget.dart';

class ExtensionsList extends StatefulWidget {
  const ExtensionsList({super.key});

  @override
  State<ExtensionsList> createState() => _ExtensionsListState();
}

class _ExtensionsListState extends State<ExtensionsList> {
  late Future<List<BibleMetaData>> _fetchData;
  @override
  void initState() {
    super.initState();
    _fetchData = _fetchExtensionsList();
  }

  Future<List<BibleMetaData>> _fetchExtensionsList() async {
    BibleExtensionInstaller installer = BibleExtensionInstaller();
    return await installer.getExtensionsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Extensions List"), centerTitle: true),
      body: FutureBuilder(
        future: _fetchData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const NormalLoader();
          } else if (snapshot.hasError) {
            return Center(
              child: NormalError(errorText: "Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No extensions found."));
          } else {
            final extensions = snapshot.data!;
            return ListView.builder(
              itemCount: extensions.length,
              itemBuilder: (context, index) {
                final extension = extensions[index];
                return ListTile(
                  onTap:
                      () => Get.to(() => ExtensionsPlayer(metaData: extension)),
                  leading: CircleAvatar(
                    child:
                        extension.hasIcon
                            ? Icon(Icons.extension)
                            : FutureBuilder<File>(
                              future:
                                  BibleExtensionInstaller.loadImageFromExtensionsDirectory(
                                    extension.package,
                                    extension.extensionIcon ?? "",
                                  ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError ||
                                    !snapshot.hasData) {
                                  return Icon(Icons.broken_image);
                                } else {
                                  return Image.file(snapshot.data!);
                                }
                              },
                            ),
                  ),
                  title: Text(extension.extensionName),
                  subtitle: Text(extension.package),
                  trailing: Icon(FontAwesomeIcons.chevronRight),
                );
              },
            );
          }
        },
      ),
    );
  }
}
