import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<dynamic> rooms = [];
  bool isLoading = true;

  static const headers = {
    'Content-Type': 'application/json'
  };

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    final url = Uri.parse("http://10.0.2.2:8000/rooms");
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final roomsData = jsonDecode(response.body);
      setState(() {
        rooms = jsonDecode(response.body);
        isLoading = false;
      });
      print('Récupération des salles réussie : $roomsData');
    } else {
      print('Erreur : ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? CircularProgressIndicator()
          : ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          final name = room['name'];
          final subject = room['subject'];
          final places = room['places'];
          final participants = room['participants'];

          return Card(
            child: ListTile(
              leading: Image.asset("assets/images/school-logo.png"),
              title: Text("$name - $subject"),
              subtitle: Text(
                  "Nombre de places : $places - Nombre de participants : $participants"),
              trailing: Icon(Icons.info),
            ),
          );
        },
      ),
    );
  }
}
