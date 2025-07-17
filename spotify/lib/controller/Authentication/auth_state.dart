import 'package:flutter/material.dart';
import 'package:spotify/controller/Authentication/auth_services.dart';
import 'package:spotify/homepage/homepage.dart';
import 'package:spotify/login&registerpages/loadingpage.dart';
import 'package:spotify/starting_pages/Gettingstartes.dart';

class AuthState extends StatelessWidget {
  final Widget? pagenotfound;

  
  const AuthState({super.key,
  this.pagenotfound,});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: authServices, 
    builder: (context, authservices, child){
     return StreamBuilder(stream: authservices.authStateChanges, builder: (context, snapshot){
      Widget widget;
      if (snapshot.connectionState == ConnectionState.waiting) {
      widget = const Loadingpage();
        
      } 
      else if (snapshot.hasData) {
      widget = const Homepage();
        
      } else {
        widget = pagenotfound ?? const GettingStarted();
      }
      return widget;
     });
    });
  }
}