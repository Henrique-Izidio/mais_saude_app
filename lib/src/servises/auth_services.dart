import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mais_saude_app/src/database/firestore.dart';
import 'package:mais_saude_app/src/models/user_model.dart';

class AuthException implements Exception {
  String mensage;
  AuthException({required this.mensage});
}

class AuthServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  final _db = DBFirestore.get();
  bool isLoading = true;
  var user;

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
      await _auth
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((uid) => {
                Fluttertoast.showToast(msg: 'Login bem sucedido'),
              });

      _getUser();
    } on FirebaseAuthException catch (e) {
      authExceptionCheck(e.code);
    }
  }

  singUpAction(email, password, name) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => {postDatailsToFirestore(name)})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
      _getUser();
    } on FirebaseAuthException catch (e) {
      authExceptionCheck(e.code);
    }
  }

  postDatailsToFirestore(name) async {
    //chamando firestore
    usuario = _auth.currentUser;
    //chamado UserModel

    UserModel userModel = UserModel();
    //enviando os dados
    userModel.email = usuario!.email;
    userModel.uid = usuario!.uid;
    userModel.name = name;

    await _db.collection('Users').doc(usuario!.uid).set(userModel.toMap());
    Fluttertoast.showToast(msg: 'Cadastro realizado com sucesso!');
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
