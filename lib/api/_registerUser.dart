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
  try {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // API Endpoint
    const String url =
        'https://47b9-152-59-241-36.ngrok-free.app/api/users/register';

    // Request body
    final Map<String, dynamic> body = {
      "username": name,
      "email": email,
      "password": password,
      "phone": phone,
    };

    // Make the POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    // Dismiss loading indicator
    Navigator.pop(context);

    // Handle response
    if (response.statusCode == 201) {
      // Successful registration
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );

      // Navigate to the HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Registration failed
      final errorMsg =
          jsonDecode(response.body)['message'] ?? 'Registration failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $errorMsg')),
      );
    }
  } catch (e) {
    // Handle any exceptions
    Navigator.pop(context); // Dismiss loading dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}
