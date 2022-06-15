import 'package:flutter/material.dart';
import 'package:mais_saude_app/src/widgets/auth_check.dart';

import 'package:provider/provider.dart';
import 'package:mais_saude_app/src/servises/auth_services.dart';
import 'package:mais_saude_app/src/config/settings.dart';

import 'package:mais_saude_app/src/pages/home/home_page.dart';
import 'package:mais_saude_app/src/pages/singin/SingInPage.dart';
import 'package:mais_saude_app/src/pages/singup/SingUp.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthServices()),
        ChangeNotifierProvider(create: (_) => AppSettings()),
        // ChangeNotifierProvider(create: (_) => UserModel(auth: context.read<AuthServices>())),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/':(_) => const AuthCheck(),
          '/home': (_) => const HomePage(),
          '/singIn': (_) => const SingInPage(),
          '/singUp': (_) => const SingUp(),
        },
      ),
    );
  }
}
