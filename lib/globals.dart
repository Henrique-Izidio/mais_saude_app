import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

enum AuthState {idle,sucess,error,loading}
