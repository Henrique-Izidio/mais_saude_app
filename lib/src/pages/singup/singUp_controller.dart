// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mais_saude_app/globals.dart';

class SingUpController extends ChangeNotifier {

  var loadState = AuthState.idle;
  late String errorMessage;
  
  Future<void> singUpAction (email, password, name)async {

    loadState = AuthState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));

    try {
      UserCredential usuario = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await firestore.collection('lista').doc(usuario.user?.uid).set({'name':name});

      notifyListeners();
    } on FirebaseAuthException catch (erro) {
      switch (erro.code) {
        case 'email-already-in-use':
          errorMessage =
              'O email já está cadastrado';
          break;
        case 'network-request-failed':
          errorMessage =
              'Você não está conectado a internet';
          break;
        default:
          errorMessage = erro.code;
        
        notifyListeners();
      }
    }
  }
}