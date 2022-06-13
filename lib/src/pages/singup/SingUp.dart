// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:mais_saude_app/src/servises/auth_services.dart';

import 'package:mais_saude_app/src/widgets/separator.dart';
import 'package:provider/provider.dart';

class SingUp extends StatefulWidget {
  const SingUp({Key? key}) : super(key: key);

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  final GlobalKey<FormState> _singUpKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  singUp() async {
    try {
      await context
          .read<AuthServices>()
          .singUpAction(email.text, password.text, name.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.mensage)));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    const Separator(
                      isSliver: false,
                      isColumn: false,
                      value: 10,
                    ),
                    TextFormField(
                      controller: name,
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
                        return null;
                      },
                    ),
                    const Separator(
                      isSliver: false,
                      isColumn: false,
                      value: 10,
                    ),
                    TextFormField(
                      controller: email,
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
                        return null;
                      },
                    ),
                    const Separator(
                      isSliver: false,
                      isColumn: false,
                      value: 10,
                    ),
                    TextFormField(
                      controller: password,
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
                      onPressed: () {
                        if (_singUpKey.currentState!.validate()) {
                          singUp();
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
    );
  }
}
