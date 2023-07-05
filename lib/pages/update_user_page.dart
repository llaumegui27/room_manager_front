import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> roles = <String>['Administrateur', 'Professeur'];

class UpdateUserPage extends StatefulWidget {
  final int userId;
  const UpdateUserPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  List<dynamic> users = [];
  String? selectedRole;


  @override
  void initState() {
    super.initState();
    fetchOneUser(widget.userId.toString());
  }

  Future<void> fetchOneUser(String userId) async {
    final url = Uri.parse("http://10.0.2.2:8000/user/$userId");
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);

      if (userData is List) {
        if (userData.isNotEmpty) {
          final user = userData.first;
          if (user.containsKey('name')) {
            nameController.text = user['name'] as String;
          }
          if (user.containsKey('mail')) {
            mailController.text = user['mail'] as String;
          }
          if (user.containsKey('password')) {
            passwordController.text = user['password'] as String;
          }
          if (user.containsKey('teacher')) {
            teacherController.text = user['teacher'].toString();
          }
          if (user.containsKey('admin')) {
            if (user['admin'] == true) {
              setState(() {
                selectedRole = roles[0];
              });
            } else {
              setState(() {
                selectedRole = roles[1];
              });
            }
          }

        }
      }
      print('Récupération de la salle réussie : $userData');
    } else {
      print('Erreur : ${response.body}');
    }
  }

  static const headers = {
    'Content-Type': 'application/json'
  };

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final teacherController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier un utilisateur"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nom Prénom',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Renseignez le nom et le prénom de l'utilisateur";
                    }
                    return null;
                  },
                  controller: nameController,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Renseignez l'e-mail";
                    }
                    return null;
                  },
                  controller: mailController,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: DropdownButtonFormField<String>(
                  items: roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  value: selectedRole,
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value;
                    });
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final name = nameController.text;
                      final mail = mailController.text;
                      final password = passwordController.text;
                      var teacher = bool.parse(teacherController.text);
                      var admin = selectedRole == roles[0];
                      if(selectedRole == roles[0]) {
                        admin = true;
                        teacher = false;
                      } else {
                        admin = false;
                        teacher = true;
                      }

                      final url =
                      Uri.parse("http://10.0.2.2:8000/update-user/${widget.userId}");
                      var body = jsonEncode({
                        "name": name,
                        "mail": mail,
                        "teacher": teacher,
                        "password": password,
                        "admin": admin,
                        "super_admin": 0
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
                            const SnackBar(
                              content: Text("Modification enregistrée."),
                            ),
                          );
                          print("Modification enregistrée et pwd $password");
                          // Effectuez d'autres actions, par exemple, naviguez vers une autre page
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Échec de la modification de l'utilisateur."),
                          ),
                        );
                        print("Échec de la modification de l'utilisateur");
                      }

                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                  child: const Text(
                    "Modifier",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
