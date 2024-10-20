import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProviders = Provider.of<AuthProviders>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to the Quiz App!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple, // Welcome text color
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20), // Space between text and button
              ElevatedButton(
                onPressed: () async {
                  await authProviders.loginWithGoogle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Button color
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 32), // Padding
                  textStyle: const TextStyle(fontSize: 18), // Button text style
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Rounded button corners
                  ),
                ),
                child: const Text('Login with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
