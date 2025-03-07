class HospitalModel {
  final String hospitalId;
  final String hospitalName;
  final String hospitalState;
  final String hospitalCity;
  final String hospitalPhone;
  final String hospitalImage;
  final String hospitalRating;

  HospitalModel({
    required this.hospitalId,
    required this.hospitalName,
    required this.hospitalState,
    required this.hospitalCity,
    required this.hospitalPhone,
    required this.hospitalImage,
    required this.hospitalRating,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      hospitalId: json['_id']?.toString() ?? '',
      hospitalName: json['name'] ?? '',
      hospitalState: json['state'] ?? '',
      hospitalCity: json['city'] ?? '',
      hospitalPhone: json['contact'] ?? '',
      hospitalImage: json['image'] ?? '',
      hospitalRating: json['rating']?.toString() ?? '0.0',
    );
  }

  static List<HospitalModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => HospitalModel.fromJson(json)).toList();
  }
}
