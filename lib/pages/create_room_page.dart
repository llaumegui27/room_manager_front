import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_url.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({Key? key}) : super(key: key);

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {

  static const headers = {
    'Content-Type': 'application/json'
  };

  final _formKey = GlobalKey<FormState>();

  final roomController = TextEditingController();
  final subjectController = TextEditingController();
  final placeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une salle"),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nom de la salle',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Renseignez le nom de la salle";
                    }
                    return null;
                  },
                  controller: roomController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Matière enseigné',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Renseignez la matière";
                    }
                    return null;
                  },
                  controller: subjectController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nombre de places',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Renseignez le nombre de places";
                    }
                    return null;
                  },
                  controller: placeController,
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()) {
                        final room = roomController.text;
                        final subject = subjectController.text;
                        final places = int.parse(placeController.text);

                        final url = Uri.parse("$apiBaseUrl/add-room");
                        var body = jsonEncode(
                            {
                              "name": room,
                              "subject": subject,
                              "places": places,
                              "participants": 0
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
                              const SnackBar(content: Text("Salle enregistré.")),
                            );
                            // Effectuez d'autres actions, par exemple, naviguez vers une autre page
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Échec de l'ajout de la salle.")),
                          );
                        }
                        FocusScope.of(context).requestFocus(FocusNode());

                      }
                    },
                    child: Text("Ajouter",
                      style: TextStyle(fontSize: 18),
                    ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
