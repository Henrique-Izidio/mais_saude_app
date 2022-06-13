// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:mais_saude_app/src/servises/auth_services.dart';
import 'package:provider/provider.dart';

class DrawerConstructor extends StatelessWidget {
  const DrawerConstructor({Key? key}) : super(key: key);

  drawerTileConstructor(IconData icon, String title) {
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

    var userDetails = Provider.of<AuthServices>(context).getDetails();
    print(userDetails['name']);

    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              child: FlutterLogo(size: 42.0),
            ),
            accountName: Text('user'),
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
