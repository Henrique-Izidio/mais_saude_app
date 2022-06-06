// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerConstructor extends StatelessWidget {
  DrawerConstructor({ Key? key }) : super(key: key);

  final _user = FirebaseAuth.instance.currentUser!;
  
  drawerTileConstructor(IconData icon, String title){
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        // ignore: avoid_print
        print(title);
      },
    );
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
              accountName: const Text('Flutter'),
              accountEmail: Text(_user.email.toString()),
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
              onTap: () async{
                await FirebaseAuth.instance.signOut();
                FirebaseAuth.instance
                .authStateChanges()
                .listen((User? user) {
                  if (user == null) {
                    Navigator.of(context).pushReplacementNamed('/');
                  } else {
                    Navigator.of(context).pushReplacementNamed('/home');
                  }
                });
              },
            )
          ],
        ),
      );
  }
}