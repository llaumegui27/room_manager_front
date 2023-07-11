import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_url.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  static const headers = {
    'Content-Type': 'application/json'
  };

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    mailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inscription"),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Inscrivez-vous",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nom Prénom',
                        hintText: "Entrez votre nom et votre prénom",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Renseignez votre nom et prénom";
                        }
                        return null;
                      },
                      controller: nameController,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        hintText: "Entrez votre e-mail",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Renseignez votre e-mail";
                        }
                        return null;
                      },
                      controller: mailController,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: "Entrez votre mot de passe",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Renseignez votre mot de passe";
                        }
                        return null;
                      },
                      controller: passwordController,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Confirmez votre mot de passe',
                        hintText: "Mot de passe",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Renseignez votre mot de passe";
                        }
                        if (value != passwordController.text) {
                          return "Les mots de passe ne correspondent pas";
                        }
                        return null;
                      },
                      controller: repeatPasswordController,
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
                          final repeatPassword = repeatPasswordController.text;

                          final url = Uri.parse("$apiBaseUrl/add-user");
                          var body = jsonEncode(
                              {
                                "name": name,
                                "mail": mail,
                                "password": password,
                                "teacher": 1,
                                "admin": 0,
                                "super_admin": 0
                              }
                              );
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
                                const SnackBar(content: Text("Inscription réussie.")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message)),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Inscription échoué.")),
                            );
                          }
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                      },
                      child: Text("S'inscrire"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
