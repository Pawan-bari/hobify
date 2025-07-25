import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:spotify_clone/Audio%20page/player.dart';
import 'package:spotify_clone/controller/Authentication/auth_state.dart';
import 'package:spotify_clone/homepage/Search/serch.dart';
import 'package:spotify_clone/homepage/homepage.dart';
import 'package:spotify_clone/homepage/profile/delete.dart';
import 'package:spotify_clone/homepage/profile/profile.dart';
import 'package:spotify_clone/homepage/profile/updateusername.dart';
import 'package:spotify_clone/login&registerpages/login.dart';
import 'package:spotify_clone/login&registerpages/loginui.dart';
import 'package:spotify_clone/login&registerpages/recoverpass.dart';
import 'package:spotify_clone/login&registerpages/register.dart';
import 'package:spotify_clone/starting_pages/Gettingstartes.dart';
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
      
      home: const AuthState(),
      routes: {
        '/getting-started': (context) => const GettingStarted(),
        'login': (context) => const Login(),
        'loginui':(context) => const Loginui(),
        'register':(context) => const Register(),
        'homepage':(context) => const Homepage(),
        'profile' :(context) => const Profile(),
        'recoverpass' :(context) => const Recoverpass(),
        'updateusername' :(context) => const Updateusername(),
        'delete':(context)=>const Delete(),
        
        'serch':(context)=>const Search(),
              },
      
      debugShowCheckedModeBanner: false,
      
    );
  }
}
