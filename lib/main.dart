import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ecommerce_flutter/controllers/auth_service.dart';
import 'package:firebase_ecommerce_flutter/provider/admin_provider.dart';
import 'package:firebase_ecommerce_flutter/views/admin_home.dart';
import 'package:firebase_ecommerce_flutter/views/cateories_page.dart';
import 'package:firebase_ecommerce_flutter/views/login.dart';
import 'package:firebase_ecommerce_flutter/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AdminProvider())
      ],
      child: MaterialApp(
        title: 'Ecommerce Admin App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routes: {
          // "/": (context) => AdminHome(),
          "/": (context) => CheckUser(),
          "/login": (context) => LoginPage(),
          "/signup": (context) => SignupPage(),
          "/home": (context) => AdminHome(),
          "/category": (context) => CateoriesPage()
        },

      ),
    );
  }
}


class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {

  @override
  void initState() {
    AuthService().isLoggedIn().then((value) {
      if(value){
        Navigator.pushReplacementNamed(context, "/home");
      }else{
        Navigator.pushReplacementNamed(context, "/login");

      }
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
