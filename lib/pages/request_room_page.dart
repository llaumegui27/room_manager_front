import 'package:flutter/material.dart';
import 'user_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'api_url.dart';

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
    final url = Uri.parse("$apiBaseUrl/reservations");
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
    } else {
      print('Erreur : ${response.body}');
    }
  }

  Future<void> rejectRequest(int id) async {
    final url = Uri.parse("$apiBaseUrl/delete-reservation/$id");
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final bool success = jsonResponse['etat'];
      final String message = jsonResponse['message'];

      if (success) {
        setState(() {
          reservations.removeWhere((room) => room['id'] == id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Réservation rejetée.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Échec de la suppression")),
      );
    }
  }

  Future<void> refreshRequests() async {
    await fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshRequests,
      child: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final dateFormatter = DateFormat('MM/dd/yyyy HH:mm');
            final reservation = reservations[index];
            final id = reservation['id'];
            final idUser = reservation['id_user_id'];
            final idRoom = reservation['id_room_id'];
            final debut = reservation['date_heure_debut'];
            final debutFormatted =
            dateFormatter.format(DateTime.parse(debut));
            final fin = reservation['date_heure_fin'];
            final finFormatted =
            dateFormatter.format(DateTime.parse(fin));
            var room = reservation["room_name"];
            final etat = reservation['etat'];
            final name = reservation['user_name'];

            if (room == null) {
              room = "Salle plus disponible";
            }
            final commentaire = reservation['commentaire'];
            return Card(
              color: etat
                  ? Colors.lightGreen.withOpacity(0.8)
                  : Colors.white60,
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
                      onPressed: () async {
                        final url = Uri.parse(
                            "$apiBaseUrl/update-reservation/$id");
                        var body = jsonEncode({
                          "date_heure_debut": debut,
                          "date_heure_fin": fin,
                          "etat": 1,
                          "commentaire": commentaire,
                          "id_user_id": idUser,
                          "id_room_id": idRoom
                        });
                        final response = await http.put(
                          url,
                          headers: headers,
                          body: body,
                        );

                        if (response.statusCode == 200) {
                          final jsonResponse =
                          jsonDecode(response.body);
                          final bool success =
                          jsonResponse['etat'];
                          final String message =
                          jsonResponse['message'];

                          if (success) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                  content:
                                  Text("Réservation acceptée.")),
                            );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                                content:
                                Text("Échec de validation")),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      color: Colors.red,
                      onPressed: () {
                        rejectRequest(id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
