import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mais_saude_app/src/servises/auth_services.dart';
import 'package:mais_saude_app/src/pages/singin/SingIn.dart';
import 'package:mais_saude_app/src/pages/home/home_page.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthServices auth = Provider.of<AuthServices>(context);
    if (auth.isLoading) {
      return loading();
    }else if (auth.usuario == null) {
      return const SingIn();
    }else {
      return const HomePage();
    }
  }

  loading(){
    return const Scaffold(
      body: Center(child: CircularProgressIndicator())
    );
  }
}