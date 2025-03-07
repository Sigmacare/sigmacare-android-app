import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sigmacare_android_app/pages/user-registration/registrationpage.dart';
import 'package:sigmacare_android_app/bottomnavigator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Uncomment if you need environment variables:
  // await dotenv.load(fileName: ".env");

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

  // Check if the auth token exists in secure storage.
  Future<bool> checkLoginStatus() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        // While the token is being fetched, show a loading indicator.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // If a token exists, navigate to BottomNavigator.
        if (snapshot.hasData && snapshot.data == true) {
          return const BottomNavigator();
        }
        // Otherwise, direct the user to the RegistrationPage.
        return const RegistrationPage();
      },
    );
  }
}
