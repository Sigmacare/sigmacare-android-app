import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _storage = const FlutterSecureStorage();
  User? _user;
  bool _isLoading = true;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to view profile')),
        );
        return;
      }

      final response = await http.get(
        Uri.parse('https://sigmacare-backend.onrender.com/api/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        setState(() {
          _user = User.fromJson(userData);
          _usernameController = TextEditingController(text: _user?.username);
          _emailController = TextEditingController(text: _user?.email);
          _phoneController = TextEditingController(text: _user?.phone);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to update profile')),
        );
        return;
      }

      final response = await http.put(
        Uri.parse('https://sigmacare-backend.onrender.com/api/users/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'username': _usernameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        _fetchUserDetails();
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? const Center(child: Text('No user data available'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _user?.profileImage != null
                              ? NetworkImage(_user!.profileImage!)
                              : null,
                          child: _user?.profileImage == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        const SizedBox(height: 20),
                        _buildEditableField(
                          'Username',
                          _usernameController,
                          Icons.person,
                          _isEditing,
                        ),
                        const SizedBox(height: 16),
                        _buildEditableField(
                          'Email',
                          _emailController,
                          Icons.email,
                          _isEditing,
                        ),
                        const SizedBox(height: 16),
                        _buildEditableField(
                          'Phone',
                          _phoneController,
                          Icons.phone,
                          _isEditing,
                        ),
                        const SizedBox(height: 24),
                        if (_isEditing)
                          ElevatedButton(
                            onPressed: _updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        _buildAppointmentsSection(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    IconData icon,
    bool isEditing,
  ) {
    return TextFormField(
      controller: controller,
      enabled: isEditing,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }

  Widget _buildAppointmentsSection() {
    if (_user?.appointments == null || _user!.appointments!.isEmpty) {
      return const Center(
        child: Text('No appointments scheduled'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Appointments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _user!.appointments!.length,
          itemBuilder: (context, index) {
            final appointment = _user!.appointments![index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(appointment['doctorName'] ?? 'Unknown Doctor'),
                subtitle: Text(
                  'Date: ${appointment['date'] ?? 'Not specified'}',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
} 