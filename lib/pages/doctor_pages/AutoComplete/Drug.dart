class Drug {
  String genericName;
  String brandName;

  Drug({this.genericName, this.brandName});

  factory Drug.fromJson(Map<String, dynamic> parsedJson) {
    return Drug(
      genericName: parsedJson["GENERIC_NAME"],
      brandName: parsedJson["BRAND_NAMES"] as String,
    );
  }
}
