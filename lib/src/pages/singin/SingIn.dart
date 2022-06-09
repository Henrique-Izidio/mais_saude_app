// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:mais_saude_app/src/servises/auth_servises.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mais_saude_app/globals.dart';

import 'package:mais_saude_app/src/widgets/separator.dart';

class SingIn extends StatefulWidget {
  const SingIn({Key? key}) : super(key: key);

  @override
  State<SingIn> createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late String email;
  late String password;
  final GlobalKey<FormState> _singInKey = GlobalKey<FormState>();
  // final controler = SingInControler();

  @override
  void initState() {
    super.initState();

    final controller = context.read<AuthServises>();

    controller.addListener(() {
      if (controller.loadState == AuthState.sucess) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else if (controller.loadState == AuthState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage),
            // content: Text('eror ao conectar'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthServises>();

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
                    key: _singInKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Bem vindo!',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const Separator(
                          isSliver: false,
                          isColumn: false,
                          value: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'E-Mail',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                              validator: (emailValue) {
                                if (emailValue == null || emailValue.isEmpty) {
                                  return 'Preencha seu nome';
                                }
                                email = emailValue;
                                return null;
                              },
                        ),
                        const Separator(
                            isSliver: false, isColumn: false, value: 15),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: 'Senha',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          validator: (passValue) {
                            if (passValue == null || passValue.isEmpty) {
                              return 'Preencha sua senha';
                            }
                            password = passValue;
                            return null;
                          },
                        ),
                        const Separator(
                            isSliver: false, isColumn: false, value: 15),
                        ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ))),
                          onPressed: controller.loadState == AuthState.loading
                              ? null
                              : () {
                                  if (_singInKey.currentState!.validate()) {
                                    controller.singInAction(email, password);
                                  }
                                },
                          child: const Padding(
                              padding: EdgeInsets.only(
                                  top: 15, bottom: 15, left: 27, right: 27),
                              child: Text('Entrar')),
                        ),
                        TextButton(
                          child: const Text(
                            'Ainda não é cadastrodo?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/singUp');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
