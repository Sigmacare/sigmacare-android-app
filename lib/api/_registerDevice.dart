import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> registerDevice(
    String deviceCode, String deviceSecret, BuildContext context) async {
  final url = Uri.parse(
      "https://sigmacare-backend.onrender.com/api/device-register"); // Replace with actual API URL

  if (deviceCode.isEmpty || deviceSecret.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Both fields are required")),
      );
    }
    return;
  }

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "device_code": deviceCode,
        "device_secret": deviceSecret,
      }),
    );

    final responseData = jsonDecode(response.body);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData["message"])),
      );
    }

    if (response.statusCode == 200 && context.mounted) {
      Navigator.pop(context); // Close dialog on success
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to register device. Try again.")),
      );
    }
  }
}
