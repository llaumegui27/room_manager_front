import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_manager.dart';

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
    final url = Uri.parse("http://10.0.2.2:8000/rooms");
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
                  validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
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
                  validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
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
                    onPressed: (){
                      if(_formKey.currentState!.validate()) {
                        final commentaire = commentaireController.text;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Envoi en cours..."))
                        );  //permet de fermer le clavier à l'envoi du form
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

