// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:mais_saude_app/src/widgets/separator.dart';
import 'package:mais_saude_app/src/pages/singup/singUp_controller.dart';
import 'package:mais_saude_app/globals.dart';

class SingUp extends StatefulWidget {
  const SingUp({Key? key}) : super(key: key);

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  final GlobalKey<FormState> _singUpKey = GlobalKey<FormState>();

  late final String name;
  late final String email;
  late final String password;

  @override
  void initState() {
    super.initState();

    final controller = context.read<SingUpController>();

    controller.addListener(() {
      if (controller.loadState == AuthState.sucess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('deu certo'),
            // content: Text('eror ao conectar'),
          ),
        );
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
    final controller = context.watch<SingUpController>();

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
                            decoration: InputDecoration(
                              labelText: 'Nome',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onChanged: (nameValue) {
                              name = nameValue;
                            },
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
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onChanged: (emailValue) {
                              email = emailValue;
                            },
                          ),
                          const Separator(
                            isSliver: false,
                            isColumn: false,
                            value: 10,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onChanged: (passValue) {
                              email = passValue;
                            },
                          ),
                          const Separator(
                            isSliver: false,
                            isColumn: false,
                            value: 10,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            onPressed: controller.loadState == AuthState.loading
                              ? null
                              : () {
                                  controller.singUpAction(email, password, name);
                                },
                            child: const Padding(
                              padding: EdgeInsets.only(
                                  top: 15, bottom: 15, left: 20, right: 20),
                              child: Text('Cadastrar'),
                            ),
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
