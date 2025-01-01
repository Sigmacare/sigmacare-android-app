import 'package:flutter/material.dart';
import 'package:sigmacare_android_app/pages/homepage/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _isProcessing = false;

  Future<void> checkEmailVerified(BuildContext context) async {
    setState(() => _isProcessing = true);

    try {
      final supabase = Supabase.instance.client;

      // Refresh the user's session to get the latest details
      final session = await supabase.auth.refreshSession();
      final user = session.user;

      print("User details: $user"); // Debugging log

      if (user?.emailConfirmedAt != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email not verified yet.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'A verification email has been sent. Please verify your email.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _isProcessing ? null : () => checkEmailVerified(context),
              child: _isProcessing
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                  : const Text('I have verified my email'),
            ),
          ],
        ),
      ),
    );
  }
}
