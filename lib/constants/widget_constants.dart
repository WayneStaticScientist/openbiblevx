import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';

class WidgetConstants {
  static List<PopUpMenuItem> getVersePopupItems() {
    return [
      PopUpMenuItem(
        title: 'highlight',
        image: FaIcon(FontAwesomeIcons.highlighter, color: Colors.white),
      ),
      PopUpMenuItem(
        title: 'Copy',
        image: FaIcon(FontAwesomeIcons.copy, color: Colors.white),
      ),
      PopUpMenuItem(
        title: 'note',
        image: FaIcon(FontAwesomeIcons.noteSticky, color: Colors.white),
      ),
      PopUpMenuItem(
        title: 'translate',
        image: FaIcon(FontAwesomeIcons.language, color: Colors.white),
      ),
      PopUpMenuItem(
        title: 'like',
        image: FaIcon(FontAwesomeIcons.heart, color: Colors.white),
      ),
      PopUpMenuItem(
        title: 'select',
        image: FaIcon(FontAwesomeIcons.check, color: Colors.white),
      ),
    ];
  }
}
