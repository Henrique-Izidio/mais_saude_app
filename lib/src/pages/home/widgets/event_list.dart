import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class EventList {
  static listEvent(snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return SliverList(
            delegate: SliverChildListDelegate([
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ]));
      case ConnectionState.active:
      case ConnectionState.done:
        if (snapshot.data!.docs.isEmpty) {
          return SliverList(
            delegate: SliverChildListDelegate([
              const Center(
                child: Text('nothing to see here'),
              )
            ]),
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
                        dialog(context, doc);
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

  static dialog(context, doc) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete event'),
            content: const Text(
                'Do you want to delete this event? This action cannot be undone.'),
            actions: <Widget>[
              ElevatedButton.icon(
                label: const Text('Delete'),
                icon: const Icon(Icons.delete_forever),
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () async {
                  await _firestore.collection('events').doc(doc.id).delete();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel'),
                style: TextButton.styleFrom(primary: Colors.blue),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
