import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mais_saude_app/src/database/firestore.dart';

class AuthException implements Exception {
  String mensage;
  AuthException({required this.mensage});
}

class AuthServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;
  final _db = DBFirestore.get();

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

  singInAction(email, password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _getUser();
    } on FirebaseAuthException catch (e) {
      authExceptionCheck(e.code);
    }
  }

  singUpAction(email, password, name) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _db
          .collection('Users')
          .doc(_auth.currentUser?.uid)
          .set({'name': name});

      _getUser();
    } on FirebaseAuthException catch (e) {
      authExceptionCheck(e.code);
    }
  }

  singOutAction() async {
    await _auth.signOut();
    _getUser();
  }

  _getUser() {
    usuario = _auth.currentUser;

    notifyListeners();
  }

  authExceptionCheck(eCode) {
    switch (eCode) {
      case 'network-request-failed':
        throw AuthException(mensage: 'Sem internet');

      case 'invalid-email':
        throw AuthException(mensage: 'E-Mail invalido');

      case 'wrong-password':
        throw AuthException(mensage: 'Senha incorreta');

      case 'weak-password':
        throw AuthException(mensage: 'Senha muito curta');

      case 'email-already-in-use':
        throw AuthException(mensage: 'O E-Mail já está cadastrado');

      case 'user-not-found':
        throw AuthException(mensage: 'Usuario não encontrado');

      default:
        throw AuthException(mensage: eCode);
    }
  }
}
