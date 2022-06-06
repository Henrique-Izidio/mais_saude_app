// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mais_saude_app/src/widgets/separator.dart';

class SingIn extends StatefulWidget {
  const SingIn({Key? key}) : super(key: key);

  @override
  State<SingIn> createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  
  FirebaseAuth auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'E-Mail',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)
                            )
                          ),
                          validator: (emailValue) {
                            if (emailValue!.contains('@') && emailValue.contains('.com')) {
                              email = emailValue;
                              return null;
                            }
                              return 'Preencha com um email valido';
                          }, 
                        ),
                        const Separator(isSliver: false, isColumn: false, value: 15),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)
                            )
                          ),
                          validator: (passValue) {
                            if (passValue!.length >= 5){
                              password = passValue;
                              return null;
                            }
                              return 'Senha invalida';
                          }, 
                        ),
                
                        const Separator(isSliver: false, isColumn: false, value: 15),

                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              )
                            )
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                // ignore: unused_local_variable
                                UserCredential userCredential = await auth.signInWithEmailAndPassword(
                                  email: email,
                                  password: password
                                );
                                auth.authStateChanges()
                                .listen(
                                  (User? user) {
                                    if (user == null) {
                                      
                                    } else {
                                      Navigator.of(context).pushReplacementNamed('/home');
                                    }
                                  }
                                );
                              } on FirebaseAuthException catch (erro) {
                                if (erro.code == 'user-not-found') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('No user found for that email.'))
                                  );
                                } else if (erro.code == 'wrong-password') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Wrong password provided for that user.'))
                                  );
                                }
                              }
                              // Navigator.of(context).pushReplacementNamed('/home');
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15, left: 27 , right: 27),
                            child: Text('Entrar')
                          ),
                        ),
                      ],
                    )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        'CADASTRAR...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.withOpacity(.9),
                        ),
                        ),
                      onPressed: (){
                        Navigator.of(context).pushReplacementNamed('/singUp');
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
