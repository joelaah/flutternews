import 'package:demo_news/auth/Login_or_register.dart';
import 'package:demo_news/pages/newsscreen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const NewsScreen();
            } else {
              return const LoginOrRegister();
            }
          }),
    );
  }
}
