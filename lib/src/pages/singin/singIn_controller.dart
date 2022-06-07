// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mais_saude_app/globals.dart';

class SingInController extends ChangeNotifier{
  var loadState = AuthState.idle;
  late String errorMessage;
  
  Future<void> singInAction (email, password)async {

    loadState = AuthState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      loadState = AuthState.sucess;
      notifyListeners();
      
    } on FirebaseAuthException catch (loginError) {
      switch (loginError.code) {
        case 'network-request-failed':
          errorMessage = 'Sem internet';
          break;
        case 'invalid-email':
          errorMessage = 'E-Mail invalido';
          break;
        case 'wrong-password':
          errorMessage = 'Senha incorreta';
          break;
        default:
          errorMessage = loginError.code;
      }
      loadState = AuthState.error;
      notifyListeners();
    }
  }

}