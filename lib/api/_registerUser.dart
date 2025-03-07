import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sigmacare_android_app/pages/homepage/homepage.dart';

Future<void> registerUser({
  required BuildContext context,
  required String name,
  required String email,
  required String password,
  required String phone,
}) async {
  // Show a loading indicator to keep your users calm while magic happens
  showDialog(
    context: context,
    barrierDismissible: false, // No accidental dismissals allowed!
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  try {
    // API Endpoint – change this if your backend URL ever decides to go on an adventure
    const String url =
        'https://sigmacare-backend.onrender.com/api/users/register';

    // Prepare the registration data payload
    final Map<String, dynamic> body = {
      "username": name,
      "email": email,
      "password": password,
      "phone": phone,
    };

    // Send a POST request to your backend
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    // Dismiss the loading indicator if it's still on stage
    if (Navigator.canPop(context)) Navigator.pop(context);

    // Check if the registration was a hit (201 Created or sometimes 200 OK)
    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );

      // Navigate to the HomePage to celebrate the new user
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Registration flopped; extract error message if available
      final responseData = jsonDecode(response.body);
      final errorMsg = responseData['message'] ?? 'Registration failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $errorMsg')),
      );
    }
  } catch (e) {
    // In case of any unexpected hiccups, dismiss the loading indicator and show the error
    if (Navigator.canPop(context)) Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}
