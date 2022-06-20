// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCenterArgs {
  final String ubsId;
  final String ubsName;
  AddCenterArgs({required this.ubsId, required this.ubsName});
}

class AddCenter extends StatefulWidget {
  static const routeName = '/addCenter';
  const AddCenter({Key? key}) : super(key: key);

  @override
  State<AddCenter> createState() => _AddCenterState();
}

class _AddCenterState extends State<AddCenter> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // final GlobalKey<FormState> _addUBSkey = GlobalKey<FormState>();
  final ubsNameController = TextEditingController();

  final ubsLocalController = TextEditingController();

  final ubsAgentController = TextEditingController();

  Stream<QuerySnapshot> _getUsers() {
    return _firestore.collection('Users').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as AddCenterArgs;

    return Scaffold(
      appBar: AppBar(title: Text(args.ubsName)),
      body: StreamBuilder<QuerySnapshot>(
          stream: _getUsers(),
          builder: (context, snapshot) {
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([]),
                ),
                listUser(snapshot, args),
              ],
            );
          }),
    );
  }

  listUser(snapshot, args) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return SliverList(
          delegate: SliverChildListDelegate([
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ]),
        );
      case ConnectionState.active:
      case ConnectionState.done:
        if (snapshot.data!.docs.isEmpty) {
          return SliverList(
            delegate: SliverChildListDelegate([
              const Expanded(
                child: Center(
                  child: Text('Não há usuários cadastrados nesta UBS'),
                ),
              ),
            ]),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index < snapshot.data!.docs.length) {
              final DocumentSnapshot doc = snapshot.data!.docs[index];
              if (doc['myUBS'] == args.ubsId) {
                // var acces = doc['accessLevel'];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(),
                    title: Text(doc['name']),
                    subtitle: Text(doc['susCard']),
                    trailing: DropdownButton(
                      value: doc['accessLevel'],
                      items: const [
                      DropdownMenuItem(
                        value: 0,
                        child: Text('Paciente'),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text('Paciente'),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text('Agente'),
                      ),
                      DropdownMenuItem(
                        value: 3,
                        child: Text('Gerente'),
                      ),
                      DropdownMenuItem(
                        value: 4,
                        child: Text('Dev'),
                      ),
                    ], onChanged: (value) async {
                      await _firestore.collection("Users").doc(doc['uid']).update({
                        'accessLevel':value
                      });
                    }),
                  ),
                );
              }
              return null;
            }
            return null;
          }),
        );
    }
  }
}
