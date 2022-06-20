import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventViewArgs {
  final DocumentSnapshot<Object?> event;

  EventViewArgs({required this.event});
}

class EventView extends StatelessWidget {
  static const routeName = '/eventView';
  const EventView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EventViewArgs;
    var date = DateTime.fromMicrosecondsSinceEpoch(
        args.event['date'].microsecondsSinceEpoch);

    return Scaffold(
      appBar: AppBar(
        title: Text(args.event['title']),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Text(
                args.event['title'],
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Text(
                  'Data: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          const Padding(
            padding:
                EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5, top: 10),
            child: Text(
              'Descrição',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              args.event['description'],
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
