class Diagnosis {
  String diseaseName;

  Diagnosis({this.diseaseName});

  factory Diagnosis.fromJson(Map<String, dynamic> parsedJson) {
    return Diagnosis(
      diseaseName: parsedJson["DISEASE_NAME"] as String,
    );
  }
}
