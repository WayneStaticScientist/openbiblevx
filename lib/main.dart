import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_bible_ai/pages/main_screen.dart';
import 'package:open_bible_ai/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_bible_ai/pages/first_time_loader.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final loaded = prefs.getBool("loaded") ?? false;
  AppConstants.dailyImage = math.Random().nextInt(AppConstants.imagesSize) + 1;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.green, // Replace with your desired color
      statusBarBrightness: Brightness.light, // For dark icons
      statusBarIconBrightness: Brightness.dark, // For white icons
      systemNavigationBarColor:
          Colors.grey[800], // Optional: Navigation bar color
      systemNavigationBarIconBrightness:
          Brightness.light, // Optional: Navigation bar icons
    ),
  );
  runApp(
    GetMaterialApp(
      defaultTransition: Transition.native,
      debugShowCheckedModeBanner: false,
      home: loaded ? MainScreen() : FirstTimeLoader(),
    ),
  );
}
