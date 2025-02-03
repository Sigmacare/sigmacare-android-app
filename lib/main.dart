import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sigmacare_android_app/bottomnavigator.dart';
import 'package:sigmacare_android_app/pages/user-registration/registrationpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized before loading environment variables and Supabase
  WidgetsFlutterBinding.ensureInitialized();

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
      home: const AppInitializer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Awaiting session check to ensure Supabase is initialized
      future: Future.delayed(
          Duration.zero, () => Supabase.instance.client.auth.currentSession),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting for session check
          return const Center(child: CircularProgressIndicator());
        }

        // After session check completes, navigate to the correct page
        final session = snapshot.data;
        if (session != null) {
          // If the user is logged in, navigate to BottomNavigator
          return const BottomNavigator();
        } else {
          // If no session, navigate to RegistrationPage
          return const RegistrationPage();
        }
      },
    );
  }
}
