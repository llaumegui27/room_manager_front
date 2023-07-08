import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_manager.dart';
import 'api_url.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {

  List<dynamic> rooms = [];
  final _formKey = GlobalKey<FormState>();

  static const headers = {
    'Content-Type': 'application/json'
  };

  String selectSalle = '1';
  DateTime selectedDateDebut = DateTime.now();
  DateTime selectedDateFin = DateTime.now();
  final commentaireController = TextEditingController();
  final idUser = UserManager().userId;


  @override
  void dispose() {
    super.dispose();
    commentaireController.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchRooms();
    print("L'id de mon user : ");
    print(UserManager().userId);
  }

  Future<void> fetchRooms() async {
    final url = Uri.parse("$apiBaseUrl/rooms");
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final roomsData = jsonDecode(response.body);
      setState(() {
        rooms = roomsData;
      });
      print('Récupération des salles réussie : $roomsData');
    } else {
      // Gérer l'erreur de la requête
      print('Erreur : ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: DropdownButtonFormField(
                  items: rooms.map<DropdownMenuItem<String>>((room) {
                    final id = room['id'].toString();
                    final name = room['name'];
                    return DropdownMenuItem(value: id, child: Text(name));
                  }).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  value: selectSalle,
                  onChanged: (value) {
                    setState(() {
                      selectSalle = value.toString();
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'Date et heure de début de la réservation',
                  ),
                  mode: DateTimeFieldPickerMode.dateAndTime,
                  autovalidateMode: AutovalidateMode.always,
                  onDateSelected: (DateTime value) {
                    setState(() {
                      selectedDateDebut = value;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'Date et heure de fin de la réservation',
                  ),
                  mode: DateTimeFieldPickerMode.dateAndTime,
                  autovalidateMode: AutovalidateMode.always,
                  onDateSelected: (DateTime value) {
                    setState(() {
                      selectedDateFin = value;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  maxLines: 4,
                  decoration: const InputDecoration(
                      labelText: 'Commentaires',
                      hintText: 'Renseignez un commentaire',
                      border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return "Renseignez les champs obligatoires";
                    }
                    return null;
                  },
                  controller: commentaireController,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()) {
                        final room = selectSalle;
                        final debut = selectedDateDebut;
                        final fin = selectedDateFin;
                        final commentaire = commentaireController.text;
                        final etat = 0;

                        final url = Uri.parse("$apiBaseUrl/add-reservation");
                        var body = jsonEncode(
                            {
                              "date_heure_debut": debut == null ? null : debut.toIso8601String(),
                              "date_heure_fin": fin == null ? null : fin.toIso8601String(),
                              "etat": 0,
                              "commentaire": commentaire,
                              "id_user_id": idUser,
                              "id_room_id": room
                            });
                        final response = await http.post(
                          url,
                          headers: headers,
                          body: body,
                        );
                        if (response.statusCode == 200) {
                          final jsonResponse = jsonDecode(response.body);
                          final bool success = jsonResponse['etat'];
                          final String message = jsonResponse['message'];

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Réservation enregistré.")),
                            );
                            print("Réservation enregistré");
                            // Effectuez d'autres actions, par exemple, naviguez vers une autre page
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Réservation échouée.")),
                          );
                          print("Réservation échouée");
                        }
                        FocusScope.of(context).requestFocus(FocusNode());

                        print("L'id de la salle : $selectSalle");
                        print("Date et heure du début du cours : $selectedDateDebut");
                        print("Date et heure de fin du cours : $selectedDateFin");
                        print("Le commentaire : $commentaire");

                      }
                    },
                    child: Text("Envoyer")),
              )
            ],
          )
      ),
    );
  }
}

