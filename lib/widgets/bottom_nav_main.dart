import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hidable/hidable.dart';

class BottomNavMain extends StatelessWidget {
  final ScrollController scrollController;
  final bool autoScroll;
  final Function prevPage;
  final Function nextPage;
  final Function activateAutoScroll;
  const BottomNavMain({
    super.key,
    required this.scrollController,
    required this.autoScroll,
    required this.prevPage,
    required this.nextPage,
    required this.activateAutoScroll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.colorScheme.surface,
      child: SafeArea(
        child: Hidable(
          controller: scrollController,
          deltaFactor: 0.1,
          child: BottomNavigationBar(
            backgroundColor: Get.theme.colorScheme.surface,
            unselectedItemColor: Get.theme.colorScheme.onSurface,
            selectedItemColor: Get.theme.colorScheme.onSurface,
            showSelectedLabels: false,
            type: BottomNavigationBarType.shifting,
            items: [
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.chevronLeft),
                label: "left",
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.earthAfrica),
                label: "language",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.arrowsUpToLine,
                  color: autoScroll ? Get.theme.colorScheme.primary : null,
                ),
                label: "auto scroll",
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.speakap),
                label: "Favorites",
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.chevronRight),
                label: "Read",
              ),
            ],
            currentIndex: 1,
            onTap: (index) {
              if (index == 0) {
                prevPage();
              }
              if (index == 3) {
                nextPage();
              }
              if (index == 2) {
                activateAutoScroll();
              }
            },
          ),
        ),
      ),
    );
  }
}
