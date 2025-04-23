import 'package:flutter/material.dart';
import 'package:open_bible_ai/constants/constants.dart';

class DailyVerse extends StatefulWidget {
  const DailyVerse({super.key});

  @override
  State<DailyVerse> createState() => _DailyVerseState();
}

class _DailyVerseState extends State<DailyVerse> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage("assets/images/${AppConstants.dailyImage}.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          "Daily Verse",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
