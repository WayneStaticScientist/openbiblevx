class BibleMetaData {
  String package;
  String indexName;
  String indexType;
  double? screenWidth;
  double? screenHeight;
  String extensionName;
  bool hasIcon = true;
  String? extensionIcon = "icon.png";
  String extensionType;
  String summary;
  String showAppBar = "true";
  String appBarTitle = "";
  String appBarColor = "default";
  String? website;

  BibleMetaData({
    required this.package,
    required this.indexName,
    required this.indexType,
    this.screenWidth,
    this.screenHeight,
    required this.extensionName,
    required this.extensionType,
    required this.summary,
    this.website,
    this.showAppBar = 'true',
    this.hasIcon = true,
  });
  Map<String, dynamic> toMap() {
    return {
      'package': package,
      'indexName': indexName,
      'indexType': indexType,
      'screenWidth': screenWidth,
      'screenHeight': screenHeight,
      'extensionName': extensionName,
      'extensionType': extensionType,
      'summary': summary,
      'website': website,
      'showAppBar': showAppBar,
      'hasIcon': hasIcon == true ? 1 : 0,
      'extensionIcon': extensionIcon,
    };
  }

  factory BibleMetaData.fromMap(Map<String, dynamic> map) {
    return BibleMetaData(
      package: (map['package'] as String?) ?? "",
      indexName: (map['indexName'] as String?) ?? "",
      indexType: (map['indexType'] as String?) ?? "",
      showAppBar: (map['showAppBar'] ?? 'true'),
      screenWidth:
          map['screenWidth'] != null ? map['screenWidth'] as double : null,
      screenHeight:
          map['screenHeight'] != null ? map['screenHeight'] as double : null,
      extensionName: (map['extensionName'] as String?) ?? "",
      extensionType: (map['extensionType'] as String?) ?? "",
      summary: (map['summary'] as String?) ?? "",
      website: map['website'] as String?,
      hasIcon: (map['hasIcon'] as int?) == 1 ? true : false,
    );
  }
}
