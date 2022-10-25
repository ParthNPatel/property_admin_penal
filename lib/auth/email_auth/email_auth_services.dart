import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../components/prefrence_manager.dart';

FirebaseAuth lFirebaseAuth = FirebaseAuth.instance;
GetStorage storage = GetStorage();

class EmailAuth {
  static Future<User?> signUp(
    String email,
    String password,
  ) async {
    try {
      User? user = (await lFirebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        PreferenceManager.setEmail(email);
        print('DATA: ===${PreferenceManager.setEmail(email)}');
        print('SignUp Successful');
        return user;
      } else {
        print('SignUp Failed');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<User?> logIn(
    String email,
    String password,
  ) async {
    try {
      User? user = (await lFirebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        PreferenceManager.setEmail(email);

        print('DATA: ===${PreferenceManager.setEmail(email)}');
        print('logIn Successful');

        return user;
      } else {
        print('LogIn Failed');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future logOut() async {
    try {
      lFirebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
