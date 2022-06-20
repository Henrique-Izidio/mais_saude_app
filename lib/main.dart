//*Flutter packages
import 'package:flutter/material.dart';

//*Firebase packages
import 'package:firebase_core/firebase_core.dart';

//*App packages
import 'package:mais_saude_app/firebase_options.dart';
import 'package:mais_saude_app/src/widgets/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await HiveConfig.start();
  runApp(const AppWidget());
}

