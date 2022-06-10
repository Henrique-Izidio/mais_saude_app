import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mais_saude_app/src/database/firestore.dart';

class EventsRepository extends ChangeNotifier {
  late FirebaseFirestore firestore;

  EventsRepository() {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    firestore = DBFirestore.get();
  }

  saveEvent(String title) async {
    await firestore.collection('Events').doc().set({
      'title': title,
    });
  }

  delete(String id) async {
    await firestore
      .collection('events')
      .doc(id)
      .delete();
  }

  _readEvents() async {
    final snapshot = await firestore.collection('Events').get();

    snapshot.docs.forEach((event) {
      
    });
  }
}
