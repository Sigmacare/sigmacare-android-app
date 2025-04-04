class User {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String? profileImage;
  final List<dynamic>? appointments;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.profileImage,
    this.appointments,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profileImage: json['profileImage'] as String?,
      appointments: json['appointments'] as List<dynamic>?,
    );
  }
} 