import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:open_bible_ai/widgets/error_widget.dart';
import 'package:open_bible_ai/widgets/loaders_widget.dart';
import 'package:open_bible_ai/pages/extensions_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_bible_ai/bible/installer/bible_meta_data.dart';
import 'package:open_bible_ai/bible/installer/extension_installer.dart';

class ExtensionsList extends StatefulWidget {
  const ExtensionsList({super.key});

  @override
  State<ExtensionsList> createState() => _ExtensionsListState();
}

class _ExtensionsListState extends State<ExtensionsList> {
  bool _deleting = false;
  late Future<List<BibleMetaData>> _fetchData;
  final List<BibleMetaData> _selectedExtensions = [];
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
      appBar: AppBar(
        title: const Text("Extensions List"),
        centerTitle: true,
        actions: [
          _selectedExtensions.isNotEmpty
              ? IconButton(
                onPressed: _deleteSelectedExtensions,
                icon: Icon(FontAwesomeIcons.trash),
              )
              : SizedBox(),
        ],
      ),
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
            return !_deleting
                ? ListView.builder(
                  itemCount: extensions.length,
                  itemBuilder: (context, index) {
                    final extension = extensions[index];
                    return ListTile(
                      selected: _selectedExtensions.contains(extension),
                      selectedTileColor:
                          Get.isDarkMode ? Colors.grey[800] : Colors.grey[300],
                      onLongPress:
                          () => setState(() {
                            if (_selectedExtensions.contains(extension)) {
                              _selectedExtensions.remove(extension);
                            } else {
                              _selectedExtensions.add(extension);
                            }
                          }),
                      onTap: () {
                        if (_selectedExtensions.isNotEmpty) {
                          setState(() {
                            if (_selectedExtensions.contains(extension)) {
                              _selectedExtensions.remove(extension);
                              return;
                            }
                            _selectedExtensions.add(extension);
                          });
                          return;
                        }
                        Get.to(() => ExtensionsPlayer(metaData: extension));
                      },
                      leading: CircleAvatar(
                        child:
                            !extension.hasIcon
                                ? Icon(Icons.extension)
                                : FutureBuilder<File>(
                                  future:
                                      BibleExtensionInstaller.loadImageFromExtensionsDirectory(
                                        extension,
                                        "icon.png",
                                      ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError ||
                                        !snapshot.hasData) {
                                      log("There was error ${snapshot.error}");
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
                )
                : Center(child: NormalLoader());
          }
        },
      ),
    );
  }

  _deleteSelectedExtensions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(Icons.delete, color: Colors.red),
          title: Text("Delete ${_selectedExtensions.length} items"),
          content: Text(
            "Are you sure to delete ${_selectedExtensions.length == 1 ? _selectedExtensions[0].extensionName : "${_selectedExtensions.length} items"}",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("no"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _confirmToDelete();
              },
              child: Text("yes"),
            ),
          ],
        );
      },
    );
  }

  _confirmToDelete() async {
    setState(() {
      _deleting = true;
    });
    final bibleExt = BibleExtensionInstaller();
    for (final i in _selectedExtensions) {
      await bibleExt.deleteExtension(i);
    }
    setState(() {
      _deleting = false;
      _fetchData = _fetchExtensionsList();
    });
  }
}
