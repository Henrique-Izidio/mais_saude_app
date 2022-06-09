import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mais_saude_app/globals.dart';

class AuthServises extends ChangeNotifier {
  var loadState = AuthState.idle;
  late String errorMessage;
  bool isLogged = false;
  late Map userCredentials ={
        'name'  : firestore.collection('Users').doc(auth.currentUser?.uid).get(),

        'email' : auth.currentUser?.email,
      };

  authException(errorCode) {
    switch (errorCode) {
      case 'network-request-failed':
        errorMessage = 'Sem internet';
        break;
      case 'invalid-email':
        errorMessage = 'E-Mail invalido';
        break;
      case 'wrong-password':
        errorMessage = 'Senha incorreta';
        break;
      case 'weak-password':
        errorMessage = 'Senha muito curta';
        break;
      case 'email-already-in-use':
        errorMessage = 'O E-Mail já está cadastrado';
        break;
      default:
        errorMessage = errorCode;

        loadState = AuthState.error;
        notifyListeners();
    }
  }

  Future<void> singInAction(email, password) async {
    loadState = AuthState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));

    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      loadState = AuthState.sucess;
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      authException(error.code);
    }
  }

  Future<void> singUpAction(email, password, name) async {
    loadState = AuthState.loading;
    notifyListeners();
    // await Future.delayed(const Duration(seconds: 2));

    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firestore
          .collection('Users')
          .doc(auth.currentUser?.uid)
          .set({'name': name});

      loadState = AuthState.sucess;
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      authException(error.code);
    }
  }

  singOutAction() async {
    await auth.signOut();
    notifyListeners();
  }
}
