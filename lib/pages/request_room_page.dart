import 'package:flutter/material.dart';
import 'user_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class RequestRoomPage extends StatefulWidget {
  const RequestRoomPage({Key? key}) : super(key: key);

  @override
  State<RequestRoomPage> createState() => _RequestRoomPageState();
}

class _RequestRoomPageState extends State<RequestRoomPage> {

  List<dynamic> reservations = [];
  bool isLoading = true;

  static const headers = {
    'Content-Type': 'application/json'
  };

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    final id = UserManager().userId;
    final url = Uri.parse("http://10.0.2.2:8000/reservations");
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final reservationssData = jsonDecode(response.body);
      setState(() {
        reservations = jsonDecode(response.body);
        reservations.sort((a, b) {
          final int idA = a['id'];
          final int idB = b['id'];
          return idB.compareTo(idA);
        });
        isLoading = false;
      });
      print('Récupération des salles réussie : $reservationssData');
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
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final dateFormatter = DateFormat('MM/dd/yyyy HH:mm');
          final reservation = reservations[index];
          final id = reservation['id'];
          final debut = reservation['date_heure_debut'];
          final debutFormatted = dateFormatter.format(DateTime.parse(debut));
          final fin = reservation['date_heure_fin'];
          final finFormatted = dateFormatter.format(DateTime.parse(fin));
          var room = reservation["room_name"];
          var etat = reservation['etat'];
          final name = reservation['user_name'];

          if (etat == true) {
            etat = "Accepté";
          } else {
            etat = "En attente ou refusé";
          }
          if (room == null) {
            room = "Salle plus disponible";
          }
          final commentaire = reservation['commentaire'];
          return Card(
            child: ListTile(
              leading: Image.asset("assets/images/juge.png"),
              title: Text("$name - $room"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$debutFormatted - $finFormatted"),
                  Text("Informations : $commentaire"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.check),
                    color: Colors.green,
                    onPressed: () {
                      // Action à effectuer lorsqu'on appuie sur le bouton "accepter"
                      // Placez votre logique ici
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.red,
                    onPressed: () {
                      // Action à effectuer lorsqu'on appuie sur le bouton "refuser"
                      // Placez votre logique ici
                    },
                  ),
                ],
              ),
            ),
          );

        },
      ),
    );
  }
}
