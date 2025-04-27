import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_bible_ai/widgets/error_widget.dart';
import 'package:open_bible_ai/widgets/loaders_widget.dart';
import 'package:open_bible_ai/widgets/extension_web_runner.dart';
import 'package:open_bible_ai/bible/installer/bible_meta_data.dart';
import 'package:open_bible_ai/bible/installer/extension_installer.dart';

class ExtensionsPlayer extends StatefulWidget {
  final BibleMetaData metaData;
  const ExtensionsPlayer({super.key, required this.metaData});
  @override
  State<ExtensionsPlayer> createState() => _ExtensionsPlayerState();
}

class _ExtensionsPlayerState extends State<ExtensionsPlayer> {
  late Future<String> _getExternalProjectDirectory;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    super.initState();
    _getExternalProjectDirectory = _openPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      body: CustomScrollView(
        slivers: [
          widget.metaData.showAppBar == 'true'
              ? SliverAppBar(
                title: Text(
                  widget.metaData.appBarTitle.isEmpty
                      ? widget.metaData.extensionName
                      : widget.metaData.appBarTitle,
                ),
              )
              : SizedBox.shrink(),
          SliverFillRemaining(
            child: FutureBuilder(
              future: _getExternalProjectDirectory,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return NormalLoader();
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NormalError(
                      errorText: "There was error : ${snapshot.error}",
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return _runView(snapshot.data!);
                }
                return NormalError(
                  errorText: "There was unknown error that arised",
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _openPath() async {
    final filePath =
        '${await BibleExtensionInstaller.getMetaDataPath(widget.metaData)}/${widget.metaData.indexName}';
    final file = File(filePath);
    if (!(await file.exists())) {
      throw Exception("The package is corrupt | no player found ${file.path}");
    }
    return filePath;
  }

  Widget _runView(String path) {
    return ExtensionWebRunner(
      path: path,
      scaffoldMessengerKey: _scaffoldMessengerKey,
    );
  }
}
