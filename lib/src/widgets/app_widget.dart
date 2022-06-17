import 'package:flutter/material.dart';
import 'package:mais_saude_app/src/pages/addEvent/addEvent.dart';
import 'package:mais_saude_app/src/pages/event/event_page.dart';
import 'package:mais_saude_app/src/pages/profile/profile_page.dart';
import 'package:mais_saude_app/src/pages/sittings_page.dart/settings_page.dart';
import 'package:mais_saude_app/src/widgets/auth_check.dart';

import 'package:provider/provider.dart';
import 'package:mais_saude_app/src/servises/auth_services.dart';

import 'package:mais_saude_app/src/pages/home/home_page.dart';
import 'package:mais_saude_app/src/pages/singin/SingIn.dart';
import 'package:mais_saude_app/src/pages/singup/SingUp.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthServices()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/':(_) => const AuthCheck(),
          '/home': (_) => const HomePage(),
          '/singIn': (_) => const SingIn(),
          '/singUp': (_) => const SingUp(),
          '/settings': (_) => const SettingsPage(),
          '/profile': (_) => const ProfilePage(),
          '/addEvent': (_) => const AddEvent(),
          EventView.routeName : (_) => const EventView(),
        },
      ),
    );
  }
}
