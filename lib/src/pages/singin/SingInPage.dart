// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mais_saude_app/src/servises/auth_services.dart';

import 'package:mais_saude_app/src/widgets/separator.dart';
import 'package:provider/provider.dart';

class SingInPage extends StatefulWidget {
  const SingInPage({Key? key}) : super(key: key);

  @override
  State<SingInPage> createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  final GlobalKey<FormState> _singInKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  singIn() async {
    try {
      await context
          .read<AuthServices>()
          .singInAction(email.text, password.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.mensage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(2, 200, 255, 1),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(
                  left: 30,
                  top: 60,
                  right: 30,
                  bottom: 60,
                ),
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color.fromRGBO(0, 217, 252, 1),
                      Color.fromRGBO(0, 186, 251, 1),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 10,
                      blurRadius: 13,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        'Faça seu login',
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: padding,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SingleChildScrollView(
//           child: SafeArea(
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//                 child: Form(
//                   key: _singInKey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         'Bem vindo!',
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontSize: 35,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 1,
//                         ),
//                       ),
//                       const Separator(
//                         isSliver: false,
//                         isColumn: false,
//                         value: 10,
//                       ),
//                       TextFormField(
//                         controller: email,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: InputDecoration(
//                           labelText: 'E-Mail',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         validator: (emailValue) {
//                           if (emailValue == null || emailValue.isEmpty) {
//                             return 'Preencha seu nome';
//                           }
//                           return null;
//                         },
//                       ),
//                       const Separator(
//                           isSliver: false, isColumn: false, value: 15),
//                       TextFormField(
//                         controller: password,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           labelText: 'Senha',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         validator: (passValue) {
//                           if (passValue == null || passValue.isEmpty) {
//                             return 'Preencha sua senha';
//                           }
//                           return null;
//                         },
//                       ),
//                       const Separator(
//                         isSliver: false,
//                         isColumn: false,
//                         value: 15,
//                       ),
//                       ElevatedButton(
//                         style: ButtonStyle(
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30.0),
//                             ),
//                           ),
//                         ),
//                         onPressed: () {
//                           if (_singInKey.currentState!.validate()) {
//                             singIn();
//                           }
//                         },
//                         child: const Padding(
//                           padding: EdgeInsets.only(
//                             top: 15,
//                             bottom: 15,
//                             left: 27,
//                             right: 27,
//                           ),
//                           child: Text('Entrar'),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text('Ainda não tem conta?'),
//                           TextButton(
//                             child: const Text(
//                               'Cadastre-se',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                             onPressed: () {
//                               Navigator.of(context).pushReplacementNamed('/singUp');
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
// ),
