class Drug {
  String genericName;
  String brandName;
  String medQuery;

  Drug({this.genericName, this.brandName, this.medQuery});

  factory Drug.fromJson(Map<String, dynamic> parsedJson) {
    return Drug(
        genericName: parsedJson["GENERIC_NAME"].toString(),
        brandName: parsedJson["BRAND_NAMES"] as String,
        medQuery: parsedJson["MED_QUERY"] as String);
  }
}
