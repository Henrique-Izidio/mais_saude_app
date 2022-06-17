// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mais_saude_app/src/models/user_model.dart';

class SingUp extends StatefulWidget {
  const SingUp({Key? key}) : super(key: key);

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  //* Conexão com a autenticação
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //* mensagem de erro
  String? errorMessage;

  //* Chave do formulario
  final GlobalKey<FormState> _singUpKey = GlobalKey<FormState>();

  //*controladores dos campos do formulario
  final nameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmEditingController = TextEditingController();
  final dropValue = ValueNotifier('');

  List<String> itens = <String>['1', '2', '3'];

  @override
  Widget build(BuildContext context) {
    //* Campo de nome
    final nameField = TextFormField(
      autofocus: false,
      controller: nameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Este campo não pode ser vazio");
        }
        if (!regex.hasMatch(value)) {
          return ("Preencha com um nome valido(Min. 3 letras)");
        }
        return null;
      },
      onSaved: (value) {
        nameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Nome",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Preencha seu E-Mail");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Insira um E-Mail valido");
        }
        return null;
      },
      onSaved: (value) {
        nameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "E-Mail",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Preencha sua senha");
        }
        if (!regex.hasMatch(value)) {
          return ("Sua senha é muito fraca(Min. 6 caracteres)");
        }
        return null;
      },
      onSaved: (value) {
        nameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Senha",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //password field
    final confirmField = TextFormField(
      autofocus: false,
      controller: confirmEditingController,
      obscureText: true,
      validator: (value) {
        if (value != passwordEditingController.text) {
          return ("Senhas diferentes");
        }
        return null;
      },
      onSaved: (value) {
        nameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Senha",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //signup button

    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: const Color.fromRGBO(2, 200, 255, 1),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child: const Text(
          "Cadastrar",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Form(
                key: _singUpKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Cadastrar',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 30),
                    nameField,
                    const SizedBox(height: 30),
                    emailField,
                    const SizedBox(height: 30),
                    passwordField,
                    const SizedBox(height: 30),
                    confirmField,
                    const SizedBox(height: 30),
                    StreamBuilder<QuerySnapshot>(
                      stream: _getCenters(),
                      builder: (_, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            
                          case ConnectionState.active:
                          case ConnectionState.done:
                            var dropOptions = snapshot.data!.docs;
                            return ValueListenableBuilder(
                              valueListenable: dropValue,
                              builder: (BuildContext context, String value, _) {
                                return DropdownButton(
                                  hint: const Text('Escolha sua UBS'),
                                  value: (value.isEmpty)?null:value,
                                  onChanged: (escolha) => dropValue.value = escolha.toString(),
                                  items: dropOptions.map((op) => DropdownMenuItem(
                                    value: op,
                                    child: Text(op['name']),
                                  )).toList(),
                                );
                              },
                            );
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    signUpButton,
                    const SizedBox(height: 30),
                    TextButton(
                      child: const Text(
                        'Já tem cadastro?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_singUpKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore(context)});
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  postDetailsToFirestore(context) async {
    // calling our firestore
    // calling our user model
    // sedning these values

    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = nameEditingController.text;
    userModel.accesLevel = 1;
    userModel.myUBS = 'MscI6Dv3KGbHooSbKEZI';

    await _firestore.collection("Users").doc(user.uid).set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.of(context).pushReplacementNamed('/home');
  }

  _getCenters() {
    return _firestore.collection('Centers').snapshots();
  }
}
