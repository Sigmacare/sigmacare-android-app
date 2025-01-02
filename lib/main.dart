import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sigmacare_android_app/bottomnavigator.dart';
import 'package:sigmacare_android_app/pages/user-registration/registrationpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Import environment variables from .env file
  await dotenv.load(fileName: ".env");

  String? url = dotenv.env['SUPABASE_URL'];
  String? anonKey = dotenv.env['SUPABASE_API_KEY'];

  // Initialize Supabase
  await Supabase.initialize(
    url: url ?? '',
    anonKey: anonKey ?? '',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sigma Care',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const SessionChecker(),
    );
  }
}

class SessionChecker extends StatelessWidget {
  const SessionChecker({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    // Check if user session exists
    if (session != null) {
      // If the user is logged in, navigate to HomePage
      return const BottomNavigator();
    } else {
      // If no session, navigate to RegistrationPage
      return const RegistrationPage();
    }
  }
}
