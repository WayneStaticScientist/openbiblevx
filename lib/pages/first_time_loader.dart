import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_bible_ai/bible/installer/bible_installer.dart';
import 'package:open_bible_ai/bible/installer/methods.dart';
import 'package:open_bible_ai/pages/main_screen.dart';
import 'package:xml/xml.dart' as xml;

class FirstTimeLoader extends StatefulWidget {
  const FirstTimeLoader({super.key});

  @override
  State<FirstTimeLoader> createState() => _FirstTimeLoaderState();
}

class _FirstTimeLoaderState extends State<FirstTimeLoader> {
  int _progress = 0;
  String _error = "";
  @override
  void initState() {
    super.initState();
    _installBible();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _error.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text('Loading... $_progress'),
                  ],
                ),
              )
              : Center(
                child: Text(_error, style: TextStyle(color: Colors.red)),
              ),
    );
  }

  Future<void> _installBible() async {
    try {
      final bibleInstaller = BibleInstaller();
      String parseString = await rootBundle.loadString('assets/book/niv.xml');
      Stream<int> loader = bibleInstaller.installBook(
        xml.XmlDocument.parse(parseString),
        Methods.defaultBible(),
      );
      await for (final i in loader) {
        if (mounted) {
          if (i == 200) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          }
          setState(() {
            _progress = i;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
    }
  }
}
