import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {

  final email;
  final password;

  sinIn(){

  }

  singUp() async{
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!'))
      );
    } on FirebaseAuthException catch (erro) {
      switch (erro.code) {
        case 'email-already-in-use':
          errorMensage =
              'O email já está cadastrado';
          break;
        case 'network-request-failed':
          errorMensage =
              'Você não está conectado a internet';
          break;
        default:
          errorMensage = erro.code;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMensage),
        ),
      );
    }
  }

  singOut(){
    
  }
}