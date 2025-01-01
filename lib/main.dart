import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sigmacare_android_app/pages/homepage/homepage.dart';
import 'package:sigmacare_android_app/pages/user-registration/registrationpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  //importing environment variables from .env file
  await dotenv.load(fileName: ".env");

  String? url = dotenv.env['SUPABASE_URL'];
  String? anonKey = dotenv.env['SUPABASE_API_KEY'];

  //initializing the supabase
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RegistrationPage(),
    );
  }
}
