import 'package:flutter/material.dart';
import 'package:sigmacare_android_app/pages/homepage/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> registerUser({
  required BuildContext context,
  required String email,
  required String password,
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

    // Get a reference to your Supabase client
    final supabase = Supabase.instance.client;

    // Create a new user
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    // Handle the response
    final User? user = response.user;

    // Check if the user is successfully created
    if (user != null) {
      print('User created: ${user.email}');

      // Dismiss the loading dialog
      Navigator.pop(context);

      // Navigate to the HomePage and remove the registration page from the stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Dismiss the loading dialog if no user is returned
      Navigator.pop(context);

      // In case the user is null but no error is received
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Please try again.')),
      );
    }
  } catch (e) {
    // Handle any exceptions
    Navigator.pop(context); // Dismiss the loading dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}
