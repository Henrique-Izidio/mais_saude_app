import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mais_saude_app/src/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mais_saude_app/src/pages/event/event_page.dart';
import 'package:mais_saude_app/src/widgets/carroussel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var page = 1;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedUser = UserModel();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int currentPage = 1;

  Stream<QuerySnapshot> _getList() {
    return _firestore.collection('Centers/${loggedUser.myUBS}/Events').snapshots();
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .get()
        .then((doc) {
      loggedUser = UserModel.fromMap(doc.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF6F6F6ff),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('${loggedUser.name}'),
              accountEmail: Text('${loggedUser.myUBS}'),
            ),
            drawerTile(Icons.person, 'Perfil', '/profile'),
            drawerTile(Icons.settings, 'Configurações', '/settings'),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                logout();
                Navigator.of(context).pushReplacementNamed('/singIn');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Demo'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x02c8ffff), Color(0x03CBFFff)],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _getList(),
          builder: (_, snapshot) {
            return CustomScrollView(
              slivers: <Widget>[
                Caroussel(),
                listEvent(snapshot),
              ],
            );
          },
        ),
      ),
      floatingActionButton: (loggedUser.accesLevel != null)
          ? (loggedUser.accesLevel! >= 2)
              ? FloatingActionButton(
                  child: const Icon(Icons.event),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/addEvent');
                  },
                )
              : null
          : null,
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 1,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle),
      //       label: 'perfil',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'inicio',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: 'configurações',
      //     ),
      //   ],
      // ),
    );
  }

  drawerTile(IconData icon, String label, String route){
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
    );
  }

// *area de codigo destinada a criação da lista de
// *dados a partir do firebase
  listEvent(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return SliverList(
          delegate: SliverChildListDelegate(
            [
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          ),
        );
      case ConnectionState.active:
      case ConnectionState.done:
        if (snapshot.data!.docs.isEmpty) {
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                const Center(
                  child: Text('Não há eventos'),
                )
              ],
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              if (index < snapshot.data!.docs.length) {
                final DocumentSnapshot doc = snapshot.data!.docs[index];
                var date = DateTime.fromMicrosecondsSinceEpoch(doc['date'].microsecondsSinceEpoch);
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed('/eventView', arguments: EventViewArgs(event: doc));
                    },
                    leading: const CircleAvatar(),
                    title: Text(doc['title']),
                    subtitle: Text('${date.day}/${date.month}/${date.year}'),
                    trailing: (loggedUser.accesLevel != null)
                    ? (loggedUser.accesLevel! >= 2)
                        ? IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              dialog(context, doc.id);
                            },
                          )
                        : null
                    : null,
                  ),
                );
              }
              return null;
            },
          ),
        );
    }
  }

  dialog(context, id) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apagar evento'),
          content: const Text(
              'Deseja apagar o evento? está ação nãopode ser desfeita.'),
          actions: <Widget>[
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
                await _firestore
                    .collection('Events')
                    .doc(id)
                    .delete()
                    .then((value) {
                  Fluttertoast.showToast(msg: "Evento excluido");
                });
              },
              label: const Text('Excluir'),
              icon: const Icon(Icons.delete_forever),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.cancel),
              label: const Text('Cancelar'),
              style: TextButton.styleFrom(primary: Colors.blue),
            ),
          ],
        );
      },
    );
  }

  // the logout function
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
