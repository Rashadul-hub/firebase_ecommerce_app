import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ecommerce_flutter/views/admin_home.dart';
import 'package:firebase_ecommerce_flutter/views/login.dart';
import 'package:firebase_ecommerce_flutter/views/signup.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        // "/": (context) => AdminHome(),
        "/": (context) => LoginPage(),
        "/login": (context) => LoginPage(),
        "/signup": (context) => SignupPage(),
        "/home": (context) => AdminHome()
      },

    );
  }
}
