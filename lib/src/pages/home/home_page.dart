import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mais_saude_app/src/pages/home/components/carroussel_slider.dart';
import 'package:mais_saude_app/src/widgets/drawer.dart';
import 'package:mais_saude_app/src/widgets/separator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_final_fields

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int currentPage = 1;

  Stream<QuerySnapshot> _getList() {
    return _firestore.collection('events').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF6F6F6ff),

      //* Construtor do menu lateral
      drawer: DrawerConstructor(),
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
                const Separator(isSliver: true, isColumn: false, value: 15.0),
                Caroussel(),
                const Separator(isSliver: true, isColumn: false, value: 15.0),
                // EventList.buildList(snapshot)
                listEvent(snapshot)
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.maps_home_work_sharp),
            label: 'UBS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Incio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake),
            label: 'CRASS',
          )
        ],
      ),
    );
  }

// *area de codigo destinada a criação da lista de
// *dados a partir do firebase
  listEvent(snapshot) {
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
                  child: Text('nothing to see here'),
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
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(),
                    title: Text(doc['title']),
                    subtitle: const Text('teste'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete event'),
                              content: const Text(
                                  'Do you want to delete this event? This action cannot be undone.'),
                              actions: <Widget>[
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await _firestore
                                        .collection('events')
                                        .doc(doc.id)
                                        .delete();
                                    Navigator.of(context).pop();
                                  },
                                  label: const Text('Delete'),
                                  icon: const Icon(Icons.delete_forever),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red)),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.cancel),
                                  label: const Text('Cancel'),
                                  style: TextButton.styleFrom(
                                      primary: Colors.blue),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              }
              return null;
            },
          ),
        );
    }
  }
}
