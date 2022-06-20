import 'package:flutter/material.dart';
import 'package:mais_saude_app/src/pages/addCenter/addCenter.dart';
import 'package:mais_saude_app/src/pages/ubsList/ubsList.dart';

//*Providers
import 'package:provider/provider.dart';
import 'package:mais_saude_app/src/servises/auth_services.dart';
import 'package:mais_saude_app/config/app_settings.dart';

//*Routes
import 'package:mais_saude_app/src/widgets/auth_check.dart';
import 'package:mais_saude_app/src/pages/home/home_page.dart';
import 'package:mais_saude_app/src/pages/singin/SingIn.dart';
import 'package:mais_saude_app/src/pages/singup/SingUp.dart';
import 'package:mais_saude_app/src/pages/addEvent/addEvent.dart';
import 'package:mais_saude_app/src/pages/event/event_page.dart';
import 'package:mais_saude_app/src/pages/profile/profile_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthServices()),
        ChangeNotifierProvider(create: (_) => AppSettings()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            
          ),
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/':(_) => const AuthCheck(),
          '/home': (_) => const HomePage(),
          '/singIn': (_) => const SingIn(),
          '/singUp': (_) => const SingUp(),
          '/profile': (_) => const ProfilePage(),
          '/addEvent': (_) => const AddEvent(),
          '/ubsList': (_) => const UbsList(),
          EventView.routeName : (_) => const EventView(),
          AddCenter.routeName : (_) => const AddCenter(),
        },
      ),
    );
  }
}
