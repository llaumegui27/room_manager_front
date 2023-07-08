import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_manager.dart';
import 'create_room_page.dart';
import 'update_room_page.dart';
import 'api_url.dart';

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

  Future<void> deleteRoom(int roomId) async {
    final url = Uri.parse("$apiBaseUrl/delete-room/$roomId");
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final bool success = jsonResponse['etat'];
      final String message = jsonResponse['message'];

      if (success) {
        setState(() {
          rooms.removeWhere((room) => room['id'] == roomId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Salle supprimée.")),
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

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    final url = Uri.parse("$apiBaseUrl/rooms");
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

  Future<void> refreshRooms() async {
    await fetchRooms();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshRooms,
      child: Center(
        child: Column(
          children: [
            if (UserManager().isAdmin == true)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateRoomPage()),
                    );
                  },
                  child: const Text(
                    'Ajouter une salle',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            Expanded(
              child: isLoading
                  ? const Center(
                child: SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: CircularProgressIndicator(),
                ),
              )
                  : ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  final id = room['id'];
                  final name = room['name'];
                  final subject = room['subject'];
                  final places = room['places'];

                  return Card(
                    color: Colors.white60,
                    child: ListTile(
                      leading: Image.asset("assets/images/school-logo.png"),
                      title: Text("$name - $subject"),
                      subtitle: Text("Nombre de places : $places"),
                      trailing: UserManager().isAdmin == true
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateRoomPage(roomId: id),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteRoom(id);
                            },
                          ),
                        ],
                      )
                          : SizedBox.shrink(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
