// ignore_for_file: constant_identifier_names

class AppConstants {
  static const String appMotoName = "OpenBibleAi";
  static const String appCompanyName = "Adlinks degenarative networks";
  static int dailyImage = 0;
  static int dailyVerse = 0;
  static const imagesSize = 11;
  static const String LCHAPTER = "lastChapter";
  static const String LVERSETEXT = "lastVerseText";
  static const String LBOOK = "lastBook";
  static const String LVERSE = "lastVerse";
  static const String LDATE = "lastDate";
  static String getDate(int milliseconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays <= 5) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
