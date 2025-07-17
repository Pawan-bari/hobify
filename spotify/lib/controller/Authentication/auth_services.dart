import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthServices> authServices =ValueNotifier(AuthServices());

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?>get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signin({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createuser({
    required String email,
    required String pass,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
  }
  Future<void> signout() async {
    await firebaseAuth.signOut();
  }
  Future<void> resetpass({
    required String email,
  })async {
    return await firebaseAuth.sendPasswordResetEmail(email: email);
  }
  Future<void>updateusername({
    required String username,
  })async{
    await currentUser!.updateDisplayName(username);
  }
  Future<void>deleteaccount({
    required String email,
    required String pass,

  })async {
    AuthCredential credential =
    EmailAuthProvider.credential(email: email, password: pass);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }
}
