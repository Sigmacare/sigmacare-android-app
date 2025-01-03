class HospitalModel {
  int hospitalId;
  String hospitalName;
  String hospitalState;
  String hospitalCity;
  String hospitalPhone;
  String hospitalImage;
  String hospitalRating;

  HospitalModel({
    required this.hospitalId,
    required this.hospitalName,
    required this.hospitalState,
    required this.hospitalCity,
    required this.hospitalPhone,
    required this.hospitalImage,
    required this.hospitalRating,
  });

  // Factory constructor to convert JSON to HospitalModel
  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      hospitalId: json['id'],
      hospitalName: json['name'],
      hospitalState: json['state'],
      hospitalCity: json['city'],
      hospitalPhone: json['phone'],
      hospitalImage: json['image'],
      hospitalRating: json['rating'],
    );
  }

  // Method to convert HospitalModel to JSON
  Map<String, dynamic> toJson() => {
        'id': hospitalId,
        'name': hospitalName,
        'state': hospitalState,
        'city': hospitalCity,
        'phone': hospitalPhone,
        'image': hospitalImage,
        'rating': hospitalRating,
      };

  // Static method to convert a list of JSON to a list of HospitalModel
  static List<HospitalModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) {
      return HospitalModel(
        hospitalId: json['id'] ?? 0,
        hospitalName: json['name'] ?? '',
        hospitalState: json['state'] ?? '',
        hospitalPhone: json['phone'] ?? '',
        hospitalCity: json['city'] ?? '',
        hospitalImage: json['image'] ?? '',
        hospitalRating: json['rating'] ?? '0.0',
      );
    }).toList();
  }
}
