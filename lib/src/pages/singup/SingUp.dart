// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:mais_saude_app/src/widgets/separator.dart';
// import 'package:mais_saude_app/constants/firebase_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mais_saude_app/globals.dart';

class SingUp extends StatefulWidget {
  const SingUp({Key? key}) : super(key: key);

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  final GlobalKey<FormState> _singUpKey = GlobalKey<FormState>();
  // final FirebaseAuth auth = FirebaseAuth.instance;

  late String errorMensage;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: Form(
                      key: _singUpKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: 'E-Mail',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            validator: (emailValue) {
                              if (emailValue == null || emailValue.isEmpty) {
                                return 'Preencha com um email valido';
                              }
                              email = emailValue;
                              return null;
                            },
                          ),
                          const Separator(
                              isSliver: false, isColumn: false, value: 10),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Senha',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            validator: (passValue) {
                              if (passValue!.length < 8) {
                                return 'A senha é muito curta';
                              }
                              password = passValue;
                              return null;
                            },
                          ),
                          const Separator(
                              isSliver: false, isColumn: false, value: 10),
                          ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ))),
                            onPressed: () async {
                              if (_singUpKey.currentState!.validate()) {
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
                            },
                            child: const Padding(
                                padding: EdgeInsets.only(
                                    top: 15, bottom: 15, left: 20, right: 20),
                                child: Text('Cadastrar')),
                          ),
                        ],
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        'LOGIN...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.withOpacity(.9),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
