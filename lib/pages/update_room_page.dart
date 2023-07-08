import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_url.dart';

class UpdateRoomPage extends StatefulWidget {
  final int roomId;
  const UpdateRoomPage({Key? key, required this.roomId}) : super(key: key);

  @override
  State<UpdateRoomPage> createState() => _UpdateRoomPageState();

}

class _UpdateRoomPageState extends State<UpdateRoomPage> {

  List<dynamic> rooms = [];

  @override
  void initState() {
    super.initState();
    print("Room ID: ${widget.roomId}");
    fetchOneRoom(widget.roomId.toString());
  }

  Future<void> fetchOneRoom(String roomId) async {
    final url = Uri.parse("$apiBaseUrl/room/$roomId");
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final roomData = jsonDecode(response.body);

      if (roomData is List) {
        if (roomData.isNotEmpty) {
          final room = roomData.first;
          if (room.containsKey('name')) {
            roomController.text = room['name'] as String;
          }
          if (room.containsKey('subject')) {
            subjectController.text = room['subject'] as String;
          }
          if (room.containsKey('places')) {
            placeController.text = room['places'].toString();
          }
        }
      } else if (roomData is Map) {
        if (roomData.containsKey('name')) {
          roomController.text = roomData['name'] as String;
        }
        if (roomData.containsKey('subject')) {
          subjectController.text = roomData['subject'] as String;
        }
        if (roomData.containsKey('places')) {
          placeController.text = roomData['places'].toString();
        }
      }
      print('Récupération de la salle réussie : $roomData');
    } else {
      print('Erreur : ${response.body}');
    }
  }


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
        title: const Text("Modifier une salle"),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
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
                margin: const EdgeInsets.only(bottom: 20),
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
                margin: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  decoration: const InputDecoration(
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

                        final url = Uri.parse("$apiBaseUrl/update-room/${widget.roomId}");
                        var body = jsonEncode(
                            {
                              "name": room,
                              "subject": subject,
                              "places": places,
                              "participants": 0
                            });
                        final response = await http.put(
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
                              const SnackBar(content: Text("Modification enregistré.")),
                            );
                            print("Modification enregistré");
                            // Effectuez d'autres actions, par exemple, naviguez vers une autre page
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Échec de la modification de la salle.")),
                          );
                          print("Échec de la modification de la salle");
                        }
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                    child: const Text("Modifier",
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
