import 'package:flutter/material.dart';

import 'package:mais_saude_app/src/pages/home/home_page.dart';
import 'package:mais_saude_app/src/pages/singin/SingIn.dart';
import 'package:mais_saude_app/src/pages/singup/SingUp.dart';

class AppWidget extends StatelessWidget {
  const AppWidget ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      initialRoute: '/',

      routes: {
        '/' : (_) => const SingIn(),
        '/home' : (_) => const HomePage(),
        '/singUp' : (_) => const SingUp(),
      },
    );
  }
}