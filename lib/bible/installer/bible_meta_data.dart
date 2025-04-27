class BibleMetaData {
  String package;
  String indexName;
  String indexType;
  double? screenWidth;
  double? screenHeight;
  String? version;
  String extensionName;
  bool hasIcon = true;
  String? extensionIcon = "icon.png";
  String extensionType;
  String summary;
  String showAppBar = "true";
  String? useScreenRatio;
  String appBarTitle = "";
  String appBarColor = "default";
  String? website;

  BibleMetaData({
    this.hasIcon = true,
    this.version,
    this.website,
    this.screenWidth,
    this.screenHeight,
    this.useScreenRatio,
    required this.summary,
    required this.package,
    required this.indexName,
    required this.indexType,
    this.showAppBar = 'true',
    required this.extensionType,
    required this.extensionName,
    this.extensionIcon = "icon.png",
  });
  Map<String, dynamic> toMap() {
    return {
      'summary': summary,
      'website': website,
      'package': package,
      'version': version,
      'indexName': indexName,
      'indexType': indexType,
      'showAppBar': showAppBar,
      'screenWidth': screenWidth,
      'screenHeight': screenHeight,
      'extensionIcon': extensionIcon,
      'extensionName': extensionName,
      'extensionType': extensionType,
      'useScreenRatio': useScreenRatio,
      'hasIcon': hasIcon == true ? 1 : 0,
    };
  }

  factory BibleMetaData.fromMap(Map<String, dynamic> map) {
    return BibleMetaData(
      website: map['website'] as String?,
      showAppBar: (map['showAppBar'] ?? 'true'),
      package: (map['package'] as String?) ?? "",
      summary: (map['summary'] as String?) ?? "",
      version: (map['version'] as String?) ?? "1.0",
      indexType: (map['indexType'] as String?) ?? "",
      indexName: (map['indexName'] as String?) ?? "",
      useScreenRatio: map['useScreenRatio'] as String?,
      hasIcon: (map['hasIcon'] as int?) == 1 ? true : false,
      extensionType: (map['extensionType'] as String?) ?? "",
      extensionName: (map['extensionName'] as String?) ?? "",
      extensionIcon: (map['extensionIcon'] as String?) ?? "icon.png",
      screenWidth:
          map['screenWidth'] != null ? map['screenWidth'] as double : null,
      screenHeight:
          map['screenHeight'] != null ? map['screenHeight'] as double : null,
    );
  }
}
