class OtitleBarInterface {
  String? titleBarColor;
  String? titleBarIconColor;
  String? titleBarTextColor;
  String? titleBarText;
  OtitleBarInterface({
    this.titleBarColor,
    this.titleBarIconColor,
    this.titleBarTextColor,
    this.titleBarText,
  });
  factory OtitleBarInterface.fromJson(Map<String, dynamic> json) {
    return OtitleBarInterface(
      titleBarColor: json['titleBarColor'] as String?,
      titleBarIconColor: json['titleBarIconColor'] as String?,
      titleBarTextColor: json['titleBarTextColor'] as String?,
      titleBarText: json['titleBarText'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'titleBarColor': titleBarColor,
      'titleBarIconColor': titleBarIconColor,
      'titleBarTextColor': titleBarTextColor,
      'titleBarText': titleBarText,
    };
  }
}
