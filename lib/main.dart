import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:open_bible_ai/pages/first_time_loader.dart';
import 'package:open_bible_ai/pages/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

Future<void> main() async {
  final prefs = await SharedPreferences.getInstance();
  final loaded = prefs.getBool("loaded") ?? false;
  WidgetsFlutterBinding.ensureInitialized();
  loadXmlData();
  runApp(
    GetMaterialApp(
      defaultTransition: Transition.native,
      home: loaded ? MainScreen() : FirstTimeLoader(),
    ),
  );
}

loadXmlData() async {
  String parseString = await rootBundle.loadString('assets/niv.xml');
  xml.XmlDocument.parse(parseString);
}
