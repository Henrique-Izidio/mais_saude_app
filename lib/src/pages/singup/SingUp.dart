// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:mais_saude_app/src/servises/auth_servises.dart';
import 'package:provider/provider.dart';

import 'package:mais_saude_app/src/widgets/separator.dart';

class SingUp extends StatefulWidget {
  const SingUp({Key? key}) : super(key: key);

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  final GlobalKey<FormState> _singUpKey = GlobalKey<FormState>();

  late String name;
  late String email;
  late String password;

  @override
  void initState() {
    super.initState();

    final controller = context.read<AuthServises>();

    controller.addListener(() {
      if (controller.loadState == AuthState.sucess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cadastro realizado com sucesso'),
          ),
        );
      } else if (controller.loadState == AuthState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthServises>();

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Center(
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
                      const Separator(
                        isSliver: false,
                        isColumn: false,
                        value: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (nameValue) {
                          if (nameValue == null || nameValue.isEmpty) {
                            return 'Preencha seu nome';
                          }
                          name = nameValue;
                          return null;
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
                        validator: (emailValue) {
                          if (emailValue == null || emailValue.isEmpty) {
                            return 'Preencha com um email valido';
                          }
                          email = emailValue;
                          return null;
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
                        validator: (passValue) {
                          if (passValue == null || passValue.isEmpty) {
                            return 'Preencha sua senha';
                          }
                          password = passValue;
                          return null;
                        },
                      ),
                      const Separator(
                        isSliver: false,
                        isColumn: false,
                        value: 10,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        onPressed: controller.loadState == AuthState.loading
                                ? null
                                : () {
                                  if (_singUpKey.currentState!.validate()) {
                                    controller.singUpAction(
                                      email,
                                      password,
                                      name,
                                    );
                                  }
                                },
                        child: const Padding(
                          padding: EdgeInsets.only(
                              top: 15, bottom: 15, left: 20, right: 20),
                          child: Text('Cadastrar'),
                        ),
                      ),
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
      ),
    );
  }
}
