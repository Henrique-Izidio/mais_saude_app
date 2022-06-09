// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mais_saude_app/src/servises/auth_servises.dart';

class DrawerConstructor extends StatelessWidget {

  final authServise = AuthServises();

  DrawerConstructor({ Key? key }) : super(key: key);
  
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
              accountName: Text(authServise.userCredentials['name']),
              accountEmail: Text(authServise.userCredentials['email']),
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
                authServise.singOutAction();
              },
            )
          ],
        ),
      );
  }
}