import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:room_manager/pages/user_manager.dart';

class MyRequestPage extends StatefulWidget {
  const MyRequestPage({Key? key}) : super(key: key);

  @override
  State<MyRequestPage> createState() => _MyRequestPageState();
}

class _MyRequestPageState extends State<MyRequestPage> {

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
    final url = Uri.parse("http://10.0.2.2:8000/user/$id/reservations");
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
            color: etat == "Accepté" ? Colors.lightGreen.withOpacity(0.8) : Colors.red.withOpacity(0.8),
            child: ListTile(
              leading: Image.asset(
                etat == "Accepté" ? "assets/images/valide.png" : "assets/images/rejete.png",
              ),
              title: Text("$etat - $room"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$debutFormatted - $finFormatted"),
                  Text("Informations : $commentaire"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}
