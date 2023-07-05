import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_manager.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  List<dynamic> users = [];
  bool isLoading = true;

  static const headers = {
    'Content-Type': 'application/json'
  };

  Future<void> deleteUser(int userId) async {
    final url = Uri.parse("http://10.0.2.2:8000/delete-user/$userId");
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final bool success = jsonResponse['etat'];
      final String message = jsonResponse['message'];

      if (success) {
        setState(() {
          users.removeWhere((user) => user['id'] == userId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Utilisateur supprimée.")),
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
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final url = Uri.parse("http://10.0.2.2:8000/users");
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final usersData = jsonDecode(response.body);
      setState(() {
        users = jsonDecode(response.body);
        isLoading = false;
      });
      print('Récupération des users réussie : $usersData');
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
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final id = user['id'];
          final name = user["name"];
          final mail = user['mail'];
          var teacher = user['teacher'];
          var admin = user['admin'];
          var role = "";
          admin == true ? role = "Administrateur" : role = "Professeur";

          final bool isAdmin = admin == true && UserManager().userId != id;
          final bool isCurrentUser = admin == true &&
              UserManager().userId == id;

          return Card(
            color: id != UserManager().userId ? Colors.white60 : Colors.tealAccent,
            child: ListTile(
              leading: Image.asset("assets/images/avatar.png"),
              title: Text("$name"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mail : $mail"),
                  Text("Rôle : $role"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isAdmin)
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                      },
                    ),
                  if (!isAdmin && !isCurrentUser)
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteUser(id);
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
