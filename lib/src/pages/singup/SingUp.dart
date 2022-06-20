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
  final susEditingController = TextEditingController();
  final nameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmEditingController = TextEditingController();
  String? currentUBS;

  List<String> itens = <String>['1', '2', '3'];

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

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
    
    //*campo do sus
    final susField = TextFormField(
      autofocus: false,
      controller: susEditingController,
      maxLength: 15,
      keyboardType: TextInputType.number,
      validator: (value) {
        RegExp regex = RegExp(r'^.{15,}$');
        if (value!.isEmpty) {
          return ("Este campo não pode ser vazio");
        }
        if (!regex.hasMatch(value)) {
          return ("Número invalido");
        }
        return null;
      },
      onSaved: (value) {
        susEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.credit_card),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Cartão do SUS",
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Form(
            key: _singUpKey,
            child: ListView(
              children: [
                const Text(
                  'Cadastrar',
                  textAlign: TextAlign.center,
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
                susField,
                const SizedBox(height: 30),
                passwordField,
                const SizedBox(height: 30),
                confirmField,
                const SizedBox(height: 30),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Centers')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('Carrengando...');
                      } else {
                        List<DropdownMenuItem> dropUBSs = [];
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          DocumentSnapshot snap = snapshot.data!.docs[i];
                          dropUBSs.add(DropdownMenuItem(
                            value: snap.id,
                            child: Text(snap['name']),
                          ));
                        }
                        return DropdownButton<dynamic>(
                          items: dropUBSs,
                          onChanged: (value){
                            setState(() {
                              currentUBS = value;
                            });
                          },
                          value: currentUBS,
                          hint: const Text('Escolha uma UBS'),
                          isExpanded: false,
                        );
                      }
                    },
                  ),
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
    );
  }

  void signUp(String email, String password) async {
    if (_singUpKey.currentState!.validate()) {
      if(currentUBS != null){
        try {
          await _auth
              .createUserWithEmailAndPassword(email: email, password: password)
              .then((value) => {postDetailsToFirestore(context)});
        } on FirebaseAuthException catch (error) {
          switch (error.code) {
            case "invalid-email":
              errorMessage = "Informe um E-Mail valido";
              break;
            case "wrong-password":
              errorMessage = "Senha errada";
              break;
            case "user-not-found":
              errorMessage = "O usuário inoformado não existe";
              break;
            case "user-disabled":
              errorMessage = "Este usuário está desativado";
              break;
            case "too-many-requests":
              errorMessage = "Entrada temporariamente bloqueada";
              break;
            case "operation-not-allowed":
              errorMessage = "Não é possivel entrar. Tente outra forma";
              break;
            case "email-already-in-use":
              errorMessage = "Este E-Mail já está sendo usado";
              break;
            default:
              errorMessage = "Ocorreu um erro desconhecido";
          }
          Fluttertoast.showToast(msg: errorMessage!);
          debugPrint(error.code);
        }
      }
    }
  }

  postDetailsToFirestore(context) async {

    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = nameEditingController.text;
    userModel.accesLevel = 1;
    userModel.myUBS = currentUBS;
    userModel.susCard = susEditingController.text;

    await _firestore.collection("Users").doc(user.uid).set(userModel.toMap());
    Fluttertoast.showToast(msg: "Conta criada com sucesso");

    Navigator.of(context).pushReplacementNamed('/home');
  }
}
