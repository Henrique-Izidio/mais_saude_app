// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mais_saude_app/src/models/user_model.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedUser = UserModel();

  //* Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timestamp? eventDate;
  Timestamp? eventHour;
  Timestamp? publicationMoment;

  //*Form key
  final GlobalKey<FormState> _formEventKey = GlobalKey<FormState>();

  //* Form controllers
  final eventTitle = TextEditingController();
  final eventDescription = TextEditingController();
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

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
      appBar: AppBar(
        title: const Text('Adicionar Evento'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 30,
          ),
          child: Form(
            key: _formEventKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: eventTitle,
                  decoration: InputDecoration(
                    hintText: 'titulo do evento',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: eventDescription,
                  minLines: 5,
                  maxLines: 100,
                  maxLength: 1500,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Descrição do evento',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Data: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${date.day}/${date.month}/${date.year}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const VerticalDivider(),
                    ElevatedButton(
                      child: const Icon(Icons.date_range),
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        setState(() {
                          if (newDate != null) {
                            date = newDate;
                          }
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    eventDate = Timestamp.fromDate(date);
                    publicationMoment = Timestamp.fromDate(DateTime.now());
                    await _firestore.collection("Centers/${loggedUser.myUBS}/Events").doc().set({
                      'title': eventTitle.text,
                      'description': eventDescription.text,
                      'date': eventDate,
                      'publication': publicationMoment,
                    }).then((value) => Navigator.pop(context));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Adicionar evento'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
