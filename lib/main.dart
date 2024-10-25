import 'package:demo_news/auth/auth.dart';
import 'package:demo_news/firebase_options.dart';

import 'package:demo_news/theme/darkmode.dart';
import 'package:demo_news/theme/lightmode.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const AuthPage(),
    theme: lightMode,
    darkTheme: darkMode,
  ));
}
