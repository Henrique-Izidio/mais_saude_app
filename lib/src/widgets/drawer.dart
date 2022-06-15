// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mais_saude_app/src/models/user_model.dart';
import 'package:mais_saude_app/src/servises/auth_services.dart';
import 'package:provider/provider.dart';

class DrawerConstructor extends StatefulWidget {
  const DrawerConstructor({Key? key}) : super(key: key);

  @override
  State<DrawerConstructor> createState() => _DrawerConstructorState();
}

class _DrawerConstructorState extends State<DrawerConstructor> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedUser = UserModel();

  drawerTileConstructor(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {

      },
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('Users').doc(user!.uid).get().then((value){
      this.loggedUser = UserModel.fromMap(value.data());
    });
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              child: FlutterLogo(size: 42.0),
            ),
            accountName: Text('${loggedUser.name}'),
            accountEmail: Text('email'),
          ),
          drawerTileConstructor(Icons.person, 'Perfil'),
          drawerTileConstructor(Icons.save, 'Salvos'),
          drawerTileConstructor(Icons.medical_services, 'Profissionais'),
          drawerTileConstructor(Icons.calendar_month, 'Calendario'),
          drawerTileConstructor(Icons.info, 'Quem Somos'),
          drawerTileConstructor(Icons.lock, 'Privacidade'),
          drawerTileConstructor(Icons.share, 'Compartilhar'),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () async {
              await context.read<AuthServices>().singOutAction();
            },
          )
        ],
      ),
    );
  }
}
