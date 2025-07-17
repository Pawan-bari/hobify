import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:spotify/homepage/homepage.dart';
import 'package:spotify/login&registerpages/login.dart';
import 'package:spotify/login&registerpages/loginui.dart';
import 'package:spotify/login&registerpages/register.dart';
import 'package:spotify/starting_pages/Gettingstartes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  debugPaintSizeEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        useMaterial3: true,
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      
      initialRoute: '/getting-started',
      routes: {
        '/getting-started': (context) => const GettingStarted(title: 'Getting Started'),
        'login': (context) => const Login(),
        'loginui':(context) => const Loginui(),
        'register':(context) => const Register(),
        'homepage':(context) => const Homepage()
      },
      
      debugShowCheckedModeBanner: false,
      
    );
  }
}
