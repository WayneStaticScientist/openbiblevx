import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_bible_ai/pages/slides/books_view_slider.dart';
import 'package:open_bible_ai/pages/slides/main_slide.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSlide(),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Colors.white,
        onButtonPressed: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        iconSize: 30,
        activeColor: Color(0xFF01579B),
        selectedIndex: _selectedTab,
        barItems: [
          BarItem(icon: FontAwesomeIcons.calendar, title: 'main'),
          BarItem(title: 'book', icon: FontAwesomeIcons.bookBible),
          BarItem(title: "Notes", icon: FontAwesomeIcons.noteSticky),
          BarItem(icon: FontAwesomeIcons.user, title: 'User'),

          /// Add more BarItem if you want
        ],
      ),
    );
  }

  Widget _getSlide() {
    switch (_selectedTab) {
      case 0:
        return MainSlide();
      case 1:
        return BooksViewSlider();
    }
    return Placeholder();
  }
}
