class Patient {
  final String id;
  final String name;
  final int age;
  final List<String> medicalConditions;
  final String? deviceId;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.medicalConditions,
    this.deviceId,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      medicalConditions: List<String>.from(json['medical_conditions'] ?? []),
      deviceId: json['device_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'medical_conditions': medicalConditions,
      if (deviceId != null) 'device_id': deviceId,
    };
  }
} 