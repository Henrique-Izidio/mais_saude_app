// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mais_saude_app/src/pages/addCenter/addCenter.dart';

class UbsList extends StatefulWidget {
  const UbsList({Key? key}) : super(key: key);

  @override
  State<UbsList> createState() => _UbsListState();
}

class _UbsListState extends State<UbsList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _addUBSkey = GlobalKey<FormState>();
  final TextEditingController ubsNameController = TextEditingController();
  final TextEditingController ubsLocalController = TextEditingController();

  Stream<QuerySnapshot> _listUBS() {
    return _firestore.collection('Centers').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UBSs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text('Adicionar UBS',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.bungee(
                          color: Colors.blue,
                        )),
                    content: Form(
                        key: _addUBSkey,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: TextFormField(
                                  controller: ubsNameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'preencha este campo';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    label: Text('Nome'),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 5.0, bottom: 5.0),
                                child: TextFormField(
                                  controller: ubsLocalController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'preencha este campo';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    label: Text('Endereço'),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ])),
                    actions: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (_addUBSkey.currentState!.validate()) {
                            await _firestore.collection('Centers').doc().set({
                              'name': ubsNameController.text,
                              'end': ubsLocalController.text,
                            }).then((value) {
                              ubsNameController.text = '';
                              ubsLocalController.text = '';
                              Navigator.pop(context);
                            });
                          }
                        },
                        icon: const Icon(Icons.send),
                        label: const Text('Adicionar'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text("Cancelar"),
                      )
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _listUBS(),
        builder: (_, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();

            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Não há UBSs cadastradas'));
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final DocumentSnapshot doc = snapshot.data!.docs[index];
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(),
                      title: Text(doc['name']),
                      subtitle: Text(doc['end']),
                      onTap: (){
                        Navigator.of(context).pushNamed('/addCenter',
                          arguments: AddCenterArgs(ubsId: doc.id, ubsName: doc['name'], ));
                      },
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
