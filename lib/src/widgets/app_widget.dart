import 'package:flutter/material.dart';
import 'package:mais_saude_app/src/config/settings.dart';

import 'package:mais_saude_app/src/pages/home/home_page.dart';
import 'package:mais_saude_app/src/pages/singin/SingIn.dart';
import 'package:mais_saude_app/src/pages/singup/SingUp.dart';
import 'package:mais_saude_app/src/servises/auth_servises.dart';
import 'package:provider/provider.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthServises()),
        ChangeNotifierProvider(create: (_) => AppSettings()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const SingIn(),
          '/home': (_) => const HomePage(),
          '/singUp': (_) => const SingUp(),
        },
      ),
    );
  }
}
