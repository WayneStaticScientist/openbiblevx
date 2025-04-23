import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter/services.dart';
import 'package:open_bible_ai/pages/main_screen.dart';
import 'package:open_bible_ai/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_bible_ai/bible/installer/methods.dart';
import 'package:open_bible_ai/bible/installer/bible_installer.dart';

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
        if (i == 200) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setInt(AppConstants.LCHAPTER, 1);
          prefs.setString(
            AppConstants.LVERSETEXT,
            BibleInstaller.getFirstVerse(),
          );
          prefs.setInt(AppConstants.LVERSE, 1);
          prefs.setInt(AppConstants.LBOOK, 1);
          if (mounted) {
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
