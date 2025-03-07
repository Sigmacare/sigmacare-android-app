class Doctor {
  final String id;
  final String name;
  final String hospitalId;
  final int experience;
  final String contact;

  Doctor({
    required this.id,
    required this.name,
    required this.hospitalId,
    required this.experience,
    required this.contact,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'] as String,
      name: json['name'] as String,
      hospitalId: json['hospitalId'] as String,
      experience: json['experience'] as int,
      contact: json['contact'] as String,
    );
  }
}
