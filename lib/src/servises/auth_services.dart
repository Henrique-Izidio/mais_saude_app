import 'package:firebase_auth/firebase_auth.dart';
import 'package:mais_saude_app/src/models/user_model.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception {
  String mensage;
  AuthException({required this.mensage});
}

class AuthServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  String? errorMessage;
  bool isLoading = true;

  AuthServices() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen(
      (User? user) {
        usuario = (user == null) ? null : user;
        isLoading = false;
        notifyListeners();
      },
    );
  }

  singOutAction() async {
    UserModel.fromMap({null});
    await _auth.signOut();
    _getUser();
  }

  _getUser() {
    usuario = _auth.currentUser;

    notifyListeners();
  }
}
