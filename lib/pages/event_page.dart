import 'package:flutter/material.dart';


class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final rooms = [
    {
      "name": "Salle Bateau",
      "heure": "13:30-17:00",
      "matiere": "Anglais - Grammaire",
      "logo": "school-logo"

    },
    {
      "name": "Salle Experience",
      "heure": "09:30-12:30",
      "matiere": "Physique chime - Manipulation",
      "logo": "school-logo"

    },
    {
      "name": "Salle Info",
      "heure": "13:30-17:30",
      "matiere": "Informatique - Réseau",
      "logo": "school-logo"

    },
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          final name = room['name'];
          final heure = room['heure'];
          final matiere = room['matiere'];
          return Card(
            child: ListTile(
              leading: Image.asset("assets/images/school-logo.png"),
              title: Text("$name"),
              subtitle: Text('$heure - $matiere'),
              trailing: Icon(Icons.info),
            ),
          );
        },

      ),
    );
  }
}
